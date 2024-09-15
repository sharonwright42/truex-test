function init()
  'setupDetailScreen()
  setupTrueX()
  setupPlayerScreen()
end function

' function setupDetailScreen()
'   m.episodeDetailScreen = m.top.findNode("EpisodeDetailScreen")
'   m.episodeDetailScreen.setFocus(true)
' end function

function setupTrueX()
  m.trueXLibrary = m.top.findNode("TruexAdLibrary")
  m.trueXLibrary.observeField("loadStatus", "onTruexLibraryLoadStatusChanged")
end function

function setupPlayerScreen()
  m.playerScreen = m.top.findNode("PlayerScreen")
  m.playerScreen.setFocus(true)
end function

function onKeyEvent(key, press) as Boolean
  result = false
  if press then
    if key = "options"
    else if key = "back"
      if m.playerScreen.visible = true
		result = false
      end if

    end if
  end if
  return result
end function
