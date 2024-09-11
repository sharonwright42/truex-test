function init()
  setupDetailScreen()
end function 

function setupDetailScreen()
  m.mediaDetailScreen = m.top.findNode("MediaDetailScreen")
  m.mediaDetailScreen.setFocus(true)
end Function

function onKeyEvent(key, press) as Boolean
  result = false
  if press then
    if key = "options"
    else if key = "back"
      if m.mediaDetailScreen.visible = true
		result = false
      end if

    end if
  end if
  return result
end function