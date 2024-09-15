sub init()
  findNodes()
  setupObservers()
  setupLoadTask()
end sub

sub findNodes()
  m.video = m.top.findNode("video")
  m.content = m.top.findNode("content")
  m.adManagerTask = invalid
end sub

sub setupObservers()
  m.top.observeField("content", "setupVideo")
end sub

sub setupLoadTask()
  m.playerScreenLoadTask = createObject("roSGNode", "PlayerScreenLoadTask")
  m.playerScreenLoadTask.observeField("content", "loadContent")
  m.playerScreenLoadTask.control = "RUN"
end sub

sub loadContent(event as Object)
  data = event.getData()
  loadVideo(m.playerScreenLoadTask.content)
end sub

sub loadVideo(content as Object)
  videoContent = createObject("RoSGNode", "ContentNode")

  videoContent.title = content.title
  videoContent.streamformat = "mp4"
  videoContent.url = content.videoUrl

  m.video.content = videoContent
  playVideo()

  if m.adManagerTask = invalid and content.adPods <> invalid then
    m.adManagerTask = createObject("roSGNode", "AdManagerTask")
    m.adManagerTask.video = m.video
    m.adManagerTask.adPods = content.adPods
    m.adManagerTask.observeField("close", "closeVideo")
    m.adManagerTask.control = "run"
  end if
end sub

sub playVideo()
  m.video.setFocus(true)
  m.video.visible = "true"
  m.video.control = "play"
end sub

sub closeVideo()
  if m.adManagerTask <> invalid then
    m.adManagerTask.unobserveField("close")
    m.adManagerTask.close = true
    m.adManagerTask = invalid
  end if

  if m.video <> invalid then
    m.video.control = "stop"
    m.video.content = invalid
  end if

  m.top.close = true
  m.video = invalid
end sub


function onKeyEvent(key as String, press as Boolean) as Boolean
  if press then
    if key = "back" then
      m.video.control = "stop"
      closeVideo()
      return true
    end if
  end if
  return false
end function
