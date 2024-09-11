function init()
  setupDetailScreen()
end function 

function setupDetailScreen()
  m.episodeDetailScreen = m.top.findNode("EpisodeDetailScreen")
  m.episodeDetailScreen.setFocus(true)
end Function

function onKeyEvent(key, press) as Boolean
  result = false
  if press then
    if key = "options"
    else if key = "back"
      if m.episodeDetailScreen.visible = true
		result = false
      end if

    end if
  end if
  return result
end function
