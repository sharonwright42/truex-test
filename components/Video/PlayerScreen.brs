sub init()
  findNodes()
  setupObservers()
  setupLoadTask()
end sub

sub findNodes()
  m.video = m.top.findNode("player")
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

function loadContent()
  setupVideo(m.playerScreenLoadTask.content)
end function

sub setupVideo(content as Object)
  videoContent = createObject("RoSGNode", "ContentNode")

  videoContent.title = content.title
  videoContent.streamformat = "mp4"
  videoContent.url = content.videoUrl

  m.video.content = videoContent
  playVideo()

  if m.adManagerTask = invalid then
    m.adManagerTask = createObject("roSGNode", "AdManagerTask")
    m.adManagerTask.video = m.video
    m.adManagerTask.adPods = content.adPods
    m.adManagerTask.control = "run"
  end if
end sub

function playVideo()
  m.video.setFocus(true)
  m.video.visible = "true"
  m.video.control = "play"
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
  if press then
    if key = "back" then
      m.video.control = "stop"
      return true
    end if
  end if
  return false
end function
