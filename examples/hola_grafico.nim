import amiga_graphics
import amiga_intuition

proc main() =
  if gfxOpen() == 0: 
    return
  if intuOpen() == 0: 
    return

  let win = OpenSimpleWindow(320, 200)
  if win == nil: 
    intuClose()
    gfxClose()
    return

  let rp = GetRastPort(win)
  if rp != nil:
    SetAPen(rp, 1)
    Move(rp, 10, 10)
    Draw(rp, 200, 100)
    RectFill(rp, 50, 50, 100, 100)
    DrawEllipse(rp, 160, 100, 40, 20)

  WaitClose(win)

  CloseWindow(win)
  intuClose()
  gfxClose()

when isMainModule:
  main()
