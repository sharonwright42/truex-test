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

function parseVideoContent(jsonObject as Object)
  if (jsonObject = invalid) return invalid

  content = createObject("roSGNode", "ContentNode")
  content.addField("title", "string", true)
  content.addField("videoUrl", "string", true)
  'content.addField("adPods", "array", true)

  content.title = jsonObject.title
  content.videoUrl = jsonObject.url
  
  return content
end function
