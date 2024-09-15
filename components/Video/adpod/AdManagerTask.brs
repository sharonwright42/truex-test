Library "Roku_Ads.brs"

sub init()
    m.top.functionName = "playContentWithAds"
end sub

function playContentWithAds()
  m.video = m.top.video
  m.adPods = m.top.adPods
  RAFAds = Roku_Ads()
  RAFAds.enableAdMeasurements(true)

  port = CreateObject("roMessagePort")
  RAFAds.stitchedAdsInit(m.adPods)
  m.video.observeFieldScoped("position", port)
  m.video.observeFieldScoped("control", port)
  m.video.observeFieldScoped("state", port)
  m.currentAdPodInfo = invalid
  m.currentAdInfo = invalid
  m.skipAds = false   'flag to skip RAF Ads

  playContent = true
  while playContent
    msg = wait(1000, port)

    if m.top.close then
      playContent = false
      exit while
    end if

    currentAd = RAFAds.stitchedAdHandledEvent(msg, {sgNode: m.video, port: port})

    if currentAd = invalid then
      m.video.setFocus(true)
    end if

    ' If the back button is selected, back out of video to the Detail Page
    if msg <> invalid and msg.getField() = "keypressed" and msg.getData() = 0 then
      m.top.close = true
      playContent = false
      exit while
    else if type(msg) = "roSGNodeEvent" and msg.getField() = "position" then
      if currentAd <> invalid then
        m.currentAdInfo = getCurrentAdInfo(currentAd)
        m.currentAdPodInfo = getCurrentAdPodInfo(currentAd)
        if currentAd.adExited = true then
          playContent = false
          exit while
        end if

        if isTrueXAd(currentAd) and currentAd.adCompleted = false then
          RAFAds.fireTrackingEvents(m.currentAdInfo, {"type": "Impression"})
          playTrueXAd(currentAd, port)
        end if
      else
        ' no ads here
      end if
    else if type(msg) = "roSGNodeEvent" and msg.getField() = "state" then
      if msg.getData() = "finished" then
        playContent = false
        m.top.close = true
        exit while
      end if
    else if type(msg) = "roSGNodeEvent" and msg.getField() = "event" then
      if m.skipAds <> true then
        m.skipAds = canSkipAds(msg)
      end if

      handleTarEvent(msg, RAFAds)
    end if
  end while
end function

'------------------------------------------------------------------------------------------
' If the user has gained the TrueX credit, the rest of the current adPod can be skipped
'
' Params:
'    * event as Object - adEvent from TrueX Library
'------------------------------------------------------------------------------------------
function canSkipAds(event as Object) as Boolean
  data = event.getData()

  return data.type = "adFreePod" or data.type = "skipCardShown"
end function

'------------------------------------------------------------------------------------------
' Checks the adSystem property in the ad to see if the ad belongs to TrueX
'
' Params:
'    * currentAd as Object - data from RAF'S stitchedAdHandledEvent()
'------------------------------------------------------------------------------------------
function isTrueXAd(currentAd as Object) as Boolean
  if currentAd = invalid then return false
  
  currentAdInfo = getCurrentAdInfo(currentAd)

  return currentAdInfo.adSystem = "trueX"
end function

'------------------------------------------------------------------------------------------
' Finds the current AdPod from the payload with RAF's stitchedAdHandledEvent()
'
' Params:
'    * currentAd as Object - data from RAF'S stitchedAdHandledEvent()
'------------------------------------------------------------------------------------------
function getCurrentAdPodInfo(currentAd as Object) as Object
  return m.adPods[currentAd.adpodindex - 1]
end function

'------------------------------------------------------------------------------------------
' Finds the current Ad from the payload with RAF's stitchedAdHandledEvent()
'
' Params:
'    * currentAd as Object - data from RAF'S stitchedAdHandledEvent()
'------------------------------------------------------------------------------------------
function getCurrentAdInfo(currentAd as Object) as Object
  return m.adPods[currentAd.adpodindex - 1].ads[currentAd.adindex - 1]
end function

'------------------------------------------------------------------------------------------
' Get the AdParameters from base64 encoded data string, decode it and parse it into an
' Associative Array
'
' Params:
'   * url as String - payload.adPods[0].ads[0].companionAds[0].url to be decoded
'------------------------------------------------------------------------------------------
function getAdParameters(url) as Object
  splitEncodedList = url.split(",")
  ba = CreateObject("roByteArray")
  encodedList = splitEncodedList[1].split(chr(10))
  decodedStringList = []

  for each encodedString in encodedList
    ba.FromBase64String(encodedString)
    asciiString = ba.toAsciiString()
    decodedStringList.push(asciiString)
  end for

  decodedString = decodedStringList.join("")

  return parseJson(decodedString)
end function

'------------------------------------------------------------------------------------------
' Initializes the TrueX Library and starts the interactive ad experience
' 
' Params:
'   * currentAd as roAssociativeArray - contains RAF ad data about the context and state
'       * adIndex : Integer, 'Index of current ad within pod
'       * adPodIndex : Integer, 'Index of current pod
'       * evtHandled : Boolean, 'True if event was handled by ad renderer
'       * adExited : Boolean, 'True if user exited ad rendering
'       * adCompleted : Boolean, 'True if ad has completed rendering
'------------------------------------------------------------------------------------------
function playTrueXAd(currentAd as Object, port as Object) as Boolean
  if m.tar <> invalid then return false

  parentView = m.top.video.getParent()
  m.tar = parentView.createChild("TruexLibrary:TruexAdRenderer")
  m.tar.observeField("event", port)

  adParameters = getAdParameters(m.currentAdInfo.companionads[0].url)
  adParameters["vast_config_url"] = "https://" + adParameters["vast_config_url"]

  m.tar.action = {
    type: "init",
    adParameters: adParameters,     'AdParameters from the url in the companionads for the current ad",
    slotType: m.currentAdInfo.renderSequence,
    supportsUserCancelStream: true,   'enables cancelStream event types, disable if channel does not support
    logLevel: 2,
    channelWidth: 1280,
    channelHeight: 720
  }

  m.tar.action = { type: "start" }
  m.tar.focusable = true
  m.tar.SetFocus(true)

  hideContentPlayer()

  return true
end function

'------------------------------------------------------------------------------------------
' Handles TAR Event
'
' Params:
'   * event as roAssociativeArray - contains TrueX Library event data from observing field
'------------------------------------------------------------------------------------------
sub handleTarEvent(event as Object, RAFAds as Object)
  adEvent = event.getData()
  eventType = adEvent.type
  
  adEventTypes = {
    "started": "PodStart"
    "firstQuartile": "FirstQuartile",
    "secondQuartile": "Midpoint",
    "thirdQuartile": "ThirdQuartile",
    "completed": "Complete"
  }

  if eventType = "videoEvent" and adEvent.subType <> "started" then
    RAFAds.fireTrackingEvents(m.currentAdInfo, {"event": adEventTypes[adEvent.subType]})
  else if eventType = "adCompleted" or eventType = "optout" OR eventType = "noAdsAvailable" or eventType = "adError" then
    RAFAds.fireTrackingEvents(m.currentAdPodInfo, {"event": "PodComplete"})
    playContentPlayer(RAFAds)
  else if eventType = "userCancelStream" or eventType = "userCancel" then
    exitContent()
  end if
end sub

'---------------------------------------
' Play Video and stop the TAR Library
'---------------------------------------
sub playContentPlayer(RAFAds as Object)
  m.tar.action = { type: "stop" }
  seekTime = 0
  
  cleanUpTrueX()

  'If the user earns the TrueX credit, can skip the rest of the adpod
  if m.skipAds = true then
    RAFAds.fireTrackingEvents(m.currentAdPodInfo, {"event": "PodComplete"})
    seekTime = m.currentAdPodInfo.renderTime + m.currentAdPodInfo.duration
    m.skipAds = false
  else
    seekTime = m.currentAdPodInfo.renderTime + m.currentAdInfo.duration
  end if

  m.video.seek = seekTime
  m.video.control = "play"
end sub

'---------------------------------------
' Hides and stops the video
'---------------------------------------
sub hideContentPlayer()
  m.video.control = "stop"
end sub

'---------------------------------------
' Cleans up the video and exit playback
'---------------------------------------
sub exitContent()
  m.tar.action = { type: "stop" }

  cleanupTrueX()
  m.top.close = "true"
  m.video.control = "stop"
end sub

'---------------------------------------
' Cleans up the TrueX Library
'---------------------------------------
sub cleanupTrueX()
  if m.tar <> invalid then
    m.tar.unobserveField("event")
    m.tar.visible = false
    m.tar.setFocus(false)
    m.top.removeChild(m.tar)
    m.tar = invalid
  end if
end sub
