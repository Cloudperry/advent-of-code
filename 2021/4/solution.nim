import ../lib
import cligen, regex

type
  BingoBoard = array[0 .. 4, array[0 .. 4, int]]
  BoardPositions = HashSet[tuple[row, col: int]]
  BingoWinData = tuple[boardI, lastDrawnNum: int; markedNumbers: BoardPositions]
  Bingo = object
    numbersDrawn: seq[int]
    boards: seq[BingoBoard]

const emptyBoard = [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]].BingoBoard
const diagWin1: BoardPositions = collect(for i in 0 .. 4: {(i, i)})
const diagWin2: BoardPositions = collect(for i in 0 .. 4: {(4-i, i)})

proc parseBingo(input: string): Bingo =
  let lines = input.splitLines()
  var boardCurrentLine: int
  for i, line in lines:
    if i == 0:
      var matches: RegexMatch
      if line.match(re"(?:(\d+),*)+", matches):
        result.numbersDrawn = matches.group(0, input).mapIt(it.parseInt)
    else:
      var col0, col1, col2, col3, col4: int
      if line == "":
        result.boards.add emptyBoard
        boardCurrentLine = 0
      elif line.scanf("$s$i$s$i$s$i$s$i$s$i", col0, col1, col2, col3, col4): #What a mess :)
        result.boards[^1][boardCurrentLine] = [col0, col1, col2, col3, col4]
        boardCurrentLine += 1

iterator coordAndValue(b: BingoBoard): tuple[row, col, value: int] =
  for rowN, row in b:
    for colN, value in row:
      yield (rowN, colN, value)

proc getRowPositions(row: int): BoardPositions =
  for col in 0 .. 4: result.incl (row, col)
proc getColPositions(col: int): BoardPositions =
  for row in 0 .. 4: result.incl (row, col)

template markBoardsDo(b: Bingo; code: untyped) =
  var markedBoards {.inject.} = newSeq[BoardPositions](b.boards.len)
  for winningNumber {.inject.} in b.numbersDrawn:
    for i {.inject.}, board in b.boards:
      for rowN, colN, number in board.coordAndValue:
        if number == winningNumber:
          markedBoards[i].incl (row: rowN, col: colN)
          if diagWin1 <= markedBoards[i] or diagWin2 <= markedBoards[i] or
          getRowPositions(rowN) <= markedBoards[i] or getColPositions(colN) <= markedBoards[i]:
            code

proc findWinningBoard(b: Bingo): BingoWinData =
  b.markBoardsDo:
    return (i, winningNumber, markedBoards[i])

proc findLastToWinBoard(b: Bingo): BingoWinData =
  var wonBoards: HashSet[int]
  b.markBoardsDo:
    wonBoards.incl i
    if wonBoards.len == b.boards.len:
      return (i, winningNumber, markedBoards[i])

proc getScore(b: Bingo, w: BingoWinData): int =
  for row, col, number in b.boards[w.boardI].coordAndValue:
    if (row, col) notin w.markedNumbers: result += number
  result *= w.lastDrawnNum

proc solvePart(part = 1.AocPart, inputFile = "") =
  let bingo = getInputWithParser(4, 2021, parseBingo, inputFile)
  if part == 1:
    let winningBoardData = bingo.findWinningBoard()
    echo getScore(bingo, winningBoardData)
  else:
    let winningBoardData = bingo.findLastToWinBoard()
    echo getScore(bingo, winningBoardData)

if isMainModule: dispatch(solvePart)
