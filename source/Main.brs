
sub main()
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)

  scene = screen.CreateScene("MainScene")
  screen.show()

  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)
    if msgType = "roSGScreenEvent"
      if msg.isScreenClosed() then return
    else if msgType = "roSGNodeEvent"
      field = msg.getField()
      data = msg.getData()
      if field = "exitChannel" and data = true
          END
      end if
    end if
  end while
end sub
