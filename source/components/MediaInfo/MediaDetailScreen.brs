sub init()
  findNodes()
  setupLayout()
  setupLoadTask()
end sub

sub findNodes()
  m.titleLabel = m.top.findNode("titleLabel")
  m.descriptionLabel = m.top.findNode("descriptionLabel")
  m.coverImage = m.top.findNode("coverImage")
  'm.videoList = m.top.findNode("videoList")
end sub

sub setupLayout()
  m.titleLabel.text = "Title"
  m.descriptionLabel.text = "all the descriptions will be here, doing what it should be"
  m.coverImage.loadWidth = "512"
  m.coverImage.loadHeight = "512"
  m.coverImage.uri = "pkg:/images/watercolor-corgi-dog.png"

  'm.videoList.itemComponentName = "VideoItem"
end sub

sub setupLoadTask()
  m.mediaLoadTask = createObject("roSGNode", "GetMediaLoadTask")
  m.mediaLoadTask.observeField("content", "loadContent")
  m.mediaLoadTask.control = "RUN"
end sub

sub loadContent()
  content = m.mediaLoadTask.content
  m.coverImage.uri = "pkg:/images/watercolor-corgi-dog.png"
  m.titleLabel.text = content.title
  m.descriptionLabel.text = content.description
  m.coverImage.uri = content.cover 
end sub
