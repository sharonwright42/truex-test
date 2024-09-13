Library "Roku_Ads.brs"

sub init()
    m.top.functionName = "playContentWithAds"
end sub

sub playContentWithAds()
  m.video = m.top.video
  m.adPods = m.top.adPods
  RAFAds = Roku_Ads()
  RAFAds.enableAdMeasurements(true)

  RAFAds.setAdUrl(m.video.content.url)
  port = CreateObject("roMessagePort")
  RAFAds.stitchedAdsInit(m.adPods)
  m.video.observeFieldScoped("position", port)
  m.video.observeFieldScoped("control", port)
  m.video.observeFieldScoped("state", port)

  playContent = true
  while playContent
    msg = wait(1000, port)
    currentAd = RAFAds.stitchedAdHandledEvent(msg, {sgNode: m.video, port: port})

    if currentAd <> invalid and currentAd.evtHandled then
      if currentAd.adExited = true then
        playContent = false
      end if
    else
      ' no ads here
    end if
end while

end sub
