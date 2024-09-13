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
  m.previewButton = m.top.findNode("previewButton")
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
  m.previewButton.text = "Preview"
  m.previewButton.iconUri = ""
  m.previewButton.focusedIconUri = ""

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
  m.previewUrl = content.previewUrl

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
end sub
