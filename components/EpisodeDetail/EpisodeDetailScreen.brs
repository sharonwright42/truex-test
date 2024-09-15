sub init()
  findNodes()
  setupLayout()
  setupObservers()
  setupLoadTask()
end sub

sub findNodes()
  m.titleLabel = m.top.findNode("titleLabel")
  m.descriptionLabel = m.top.findNode("descriptionLabel")
  m.coverImage = m.top.findNode("coverImage")
  m.buttonGroup = m.top.findNode("buttonGroup")
  m.playButton = m.top.findNode("playButton")
end sub

sub setupLayout()
  m.titleLabel.text = ""
  m.titleLabel.font = "font:LargeBoldSystemFont" 
  m.descriptionLabel.text = ""
  m.descriptionLabel.font = "font:SmallSystemFont"
  m.coverImage.loadWidth = "512"
  m.coverImage.loadHeight = "512"
  m.playButton.text = "Play"
  m.playButton.iconUri = ""
  m.playButton.focusedIconUri = ""

  m.top.setFocus(true)
end sub

sub setupObservers()
  m.playButton.ObserveField("buttonSelected", "onButtonSelected")
end sub

sub setupLoadTask()
  m.episodeDetailLoadTask = createObject("roSGNode", "EpisodeDetailLoadTask")
  m.episodeDetailLoadTask.observeField("content", "loadContent")
  m.episodeDetailLoadTask.control = "RUN"
end sub

sub loadContent()
  content = m.episodeDetailLoadTask.content
  m.titleLabel.text = content.title
  m.descriptionLabel.text = content.description
  m.coverImage.uri = content.cover
  m.videoUrl = content.videoUrl

  m.buttonGroup.setFocus(true)
  m.playButton.setFocus(true)
end sub

sub onButtonSelected(event as Object)
  data = event.GetRoSGNode()
  videoData = createObject("roSGNode", "ContentNode")
  videoData.addField("title", "string", true)
  videoData.addField("videoUrl", "string", true)
  videoData.title = data.title

  if (data.id = "playButton")
    videoData.videoUrl = m.videoUrl
  else
    videoData.videoUrl = m.previewUrl
  end if
  'redirect to video screen here
  setupPlayerScreen(videoData)
end sub

function setupPlayerScreen(videoData as Object)
  if m.playerScreen <> invalid then return false
  m.playerScreen = createObject("roSGNode", "PlayerScreen")
  m.playerScreen.id = "PlayerScreen"
  m.playerScreen.observeField("close", "closePlayerScreen")
  m.playerScreen.content = videoData

  m.playerScreen.visible = true
  parentView = m.top.getParent()

  parentView.appendChild(m.playerScreen)
  m.playerScreen.setFocus(true)
end function

function closePlayerScreen()
  m.playerScreen.content = invalid
  m.playerScreen.unobserveField("close")

  parentView = m.top.getParent()
  currentView = parentView.getChild(0)
  currentView.visible = true
  currentView.setFocus(true)
  m.buttonGroup.setFocus(true)
  m.playButton.setFocus(true)

  m.playerScreen.visible = false
  parentView.removeChildIndex(parentView.getChildCount() - 1)
  m.playerScreen = invalid
end function
