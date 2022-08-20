import sets, strscans, strutils
import ../common

proc runLine(program: seq[string], env: var tuple[acc, lineN: int]): int =
  result = -1
  var
    instruction: string
    argument: int
  if program[env.lineN].scanf("$+ $i", instruction, argument):
    #echo instruction, " ", argument
    if instruction == "nop":
      result = env.lineN
      env.lineN += 1
    elif instruction == "acc":
      env.acc += argument
      env.lineN += 1
    elif instruction == "jmp":
      result = env.lineN
      env.lineN += argument

proc runProgram(program: seq[string]): tuple[jumpsAndNops: HashSet[int],
                                             finished: bool, acc: int] =
  result.finished = false
  var env: tuple[acc, lineN: int]
  var linesRan: HashSet[int]
  while true:
    if not linesRan.containsOrIncl(env.lineN):
      let jumpOrNopLine = runLine(program, env)
      if jumpOrNopLine >= 0: result.jumpsAndNops.incl(jumpOrNopLine)
      result.acc = env.acc
    else:
      break
    if env.lineN > program.high:
      result.finished = true
      break

var input = getInput()

let firstRunData = runProgram(input)
for jumpOrNopLine in firstRunData.jumpsAndNops:
  proc swapNopAndJmp(line: var string) =
    if "jmp" in line:
      line = line.replace("jmp", "nop")
    else:
      line = line.replace("nop", "jmp")
  input[jumpOrNopLine].swapNopAndJmp()
  let runData = runProgram(input)
  if runData.finished:
    echo runData.acc
    break
  else:
    input[jumpOrNopLine].swapNopAndJmp()
