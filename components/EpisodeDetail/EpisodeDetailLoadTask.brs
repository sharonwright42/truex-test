sub init()
  m.top.functionName = "getMediaInfo"
end sub

sub getMediaInfo()
  content = createObject("roSGNode", "ContentNode")

  payload = readAsciiFile("pkg:/components/video/payload.json")

  if (payload <> invalid)
    json = parseJson(payload)
    content = parseToMedia(json)
  end if
  m.top.content = content
end sub

function parseToMedia(jsonObject as Object)
  content = createEmptyMediaObject()

  if (jsonObject = invalid) return content

  content.title = jsonObject.title
  content.description = jsonObject.description
  content.cover = jsonObject.cover
  content.previewUrl = jsonObject.preview
  content.videoUrl = jsonObject.url
  
  return content
end function

function createEmptyMediaObject()
  content = createObject("roSGNode", "ContentNode")

  content.addField("title", "string", true)
  content.addField("description", "string", true)
  content.addField("cover", "string", true)
  content.addField("videoUrl", "string", true)
  content.addField("previewUrl", "string", true)

  content.title = ""
  content.description = ""
  content.cover = ""
  content.videoUrl = ""
  content.previewUrl = ""

  return content
end function
