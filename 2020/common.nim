import os, strutils, sequtils

const defaultInputFile = "input.txt"

proc getFilenameAndCheckExists(filename: string): string =
  result =
    if paramCount() == 1:
      paramStr(1)
    else:
      filename
  if not fileExists(filename):
    quit("Input file " & filename & " in current working directory " &
         getCurrentDir())

proc getInput*(filename = defaultInputFile): seq[string] =
  let filename = getFilenameAndCheckExists(filename)
  for line in lines(getCurrentDir() & '/' & filename):
    result.add(line)

proc getInputAsInt*(filename = defaultInputFile): seq[int] =
  let filename = getFilenameAndCheckExists(filename)
  for line in lines(getCurrentDir() & '/' & filename):
    result.add parseInt(line)

proc parseCsvInts*(line: string): seq[int] =
  line.split(',').mapIt(it.strip.parseInt())
