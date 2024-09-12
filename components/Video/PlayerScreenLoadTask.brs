sub init()
  m.top.functionName = "getVideoContent"
end sub
  
sub getVideoContent()
  content = createObject("roSGNode", "ContentNode")
  
  payload = readAsciiFile("pkg:/components/video/payload.json")
  
  if (payload <> invalid)
    json = parseJson(payload)
    content = parseVideoContent(json)
    m.top.content = content
  end if

end sub

function parseVideoContent(jsonObject as Object) as Object
  if (jsonObject = invalid) return invalid

  content = createObject("roSGNode", "ContentNode")
  content.addField("title", "string", true)
  content.addField("videoUrl", "string", true)
  content.addField("adPods", "roArray", true)

  content.title = jsonObject.title
  content.videoUrl = jsonObject.url
  
  if (jsonObject.adPods <> invalid) then
    content.adPods = parseAdPods(jsonObject.adPods)
  end if
 
  return content
end function

function parseAdPods(adpods as Object)
  adPodArray = []
  
  for each adPodObj in adpods
    adPod = createObject("roSGNode", "AdPod")
    adPod.duration = adPodObj.duration
    adPod.renderTime = adPodObj.rendertime
    adPod.renderSequence = adPodObj.rendersequence
    adPod.tracking = adPodObj.tracking
    adPod.viewed = adPodObj.viewed
    adPod.ads = parseAds(adPodObj.ads)
    adPodArray.push(adPod)
  end for 

  return adPodArray
end function

function parseAds(ads as Object)
  adArray = []

  for each adObj in ads
    ad = createObject("roSGNode", "Ad")
    ad.adId = adObj.adid
    ad.adServer = adObj.adserver
    ad.adSystem = adObj.adsystem
    ad.adTitle = adObj.adtitle
    ad.companionAds = adObj.companionads
    ad.creativeAdId = adObj.creativeadid
    ad.creativeId = adObj.creativeId
    ad.duration = adObj.duration
    ad.requestId = adObj.requestid
    ad.streamFormat = adObj.streamformat
    ad.streams = adObj.streams
    ad.tracking = adObj.tracking
    adArray.push(ad)
  end for

  return adArray
end function
