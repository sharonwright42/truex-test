function init()
  findNodes()
  setupDetailScreen()
  setupTrueX()
end function

function findNodes()
  m.screensContainer = m.top.findNode("screensContainer")
end function

function setupDetailScreen()
  m.episodeDetailScreen = m.top.findNode("EpisodeDetailScreen")
  m.episodeDetailScreen.setFocus(true)
end function

function setupTrueX()
  m.trueXLibrary = m.top.findNode("TruexAdLibrary")
  m.trueXLibrary.observeField("loadStatus", "onTruexLibraryLoadStatusChanged")
end function

'---------------------------------------
' Print out the load status of TrueX
'---------------------------------------
function onTruexLibraryLoadStatusChanged(event as Object)
  if m.trueXLibrary = invalid then return false

  print m.trueXLibrary.loadStatus
end function

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
