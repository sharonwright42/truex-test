sub init()
  findNodes()
  setupObservers()
  setupLoadTask()
end sub

sub findNodes()
  m.video = m.top.findNode("player")
  m.content = m.top.findNode("content")
end sub

sub setupObservers()
  m.top.observeField("content", "setupVideo")
end sub

sub setupVideo(content as Object)
  videoContent = createObject("RoSGNode", "ContentNode")
  ? videoContent

  videoContent.title = content.title
  videoContent.streamformat = "mp4"
  videoContent.url = content.videoUrl
  
  m.video.content = videoContent
  playVideo()
end sub

sub setupLoadTask()
  m.playerScreenLoadTask = createObject("roSGNode", "PlayerScreenLoadTask")
  m.playerScreenLoadTask.observeField("content", "loadContent")
  m.playerScreenLoadTask.control = "RUN"
end sub

function loadContent()
  setupVideo(m.playerScreenLoadTask.content)
end function

function playVideo()
  m.video.setFocus(true)
  m.video.visible = "true"
  m.video.control = "play"
end function
