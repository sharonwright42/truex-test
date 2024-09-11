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
  content.videoList.push({"Preview": jsonObject.preview})
  content.videoList.push({"Video": jsonObject.url})

  return content
end function

function createEmptyMediaObject()
  content = createObject("roSGNode", "ContentNode")

  content.addField("title", "string", true)
  content.addField("description", "string", true)
  content.addField("cover", "string", true)
  content.addField("videoList", "array", true)

  content.title = ""
  content.description = ""
  content.cover = ""
  content.videoList = []

  return content
end function
