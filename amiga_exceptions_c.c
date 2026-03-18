# Exception handling minimo (setjmp/longjmp)
{.deadCodeElim: on.}
{.push inline.}

type
  NI32* = uint32
  JmpBuf* = array[20, NI32]
  PBuf* = ptr JmpBuf

var gEnvStack*: array[16, PBuf]
var gEnvTop*: int = 0

proc pushEnv*(env: PBuf) =
  if gEnvTop < 16:
    gEnvStack[gEnvTop] = env
    inc gEnvTop

proc popEnv*() =
  if gEnvTop > 0:
    dec gEnvTop

proc currentEnv*(): PBuf =
  if gEnvTop > 0:
    result = gEnvStack[gEnvTop - 1]
  else:
    result = nil

proc c_setjmp*(env: PBuf): NI32 {.importc: "nim_setjmp".}
proc c_longjmp*(env: PBuf; val: NI32) {.importc: "nim_longjmp".}

template try*(body: untyped, handler: untyped): untyped =
  var env: JmpBuf
  pushEnv(addr env)
  if c_setjmp(addr env) == 0:
    body
  else:
    handler
  popEnv()

proc throw*(code: NI32) =
  let env = currentEnv()
  if env != nil:
    c_longjmp(env, if code == 0: 1 else: code)

{.pop.}
