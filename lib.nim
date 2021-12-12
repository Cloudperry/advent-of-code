import os, httpclient
import math, strutils, strformat, strscans, sequtils, tables, sets, hashes, times, sugar, options, algorithm, lenientops
export math, strutils, strformat, strscans, sequtils, tables, sets, hashes, times, sugar, options, algorithm, lenientops

type
  AocPart* = range[1 .. 2]
  AocDay* = range[1 .. 25]
  AocYear* = range[2015 .. int.high]

proc getInputIfNotDownloaded(day: AocDay; year: AocYear) =
  if not fileExists("input.txt"):
    var client = newHttpClient()
    let sessionCookie = readFile("../sessionCookie").strip
    client.headers = newHttpHeaders({ "Cookie": fmt"session={sessionCookie}" })
    echo fmt"downloading https://adventofcode.com/{year}/day/{day}/input"
    client.downloadFile(fmt"https://adventofcode.com/{year}/day/{day}/input", "input.txt")

proc getInput*(day: AocDay, year: AocYear; inputFile = ""): string =
  if not inputFile.isEmptyOrWhitespace:
    result = readFile(inputFile)
  else:
    getInputIfNotDownloaded(day, year)
    result = readFile("input.txt")
  if result[^1] in Whitespace: result.delete(result.high .. result.high)

proc getInputLines*(day: AocDay, year: AocYear; inputFile = ""): seq[string] =
  let inputRaw = getInput(day, year, inputFile)
  for line in splitLines(inputRaw): result.add line

proc getInputLinesWithParser*[T](day: AocDay, year: AocYear; parser: proc (input: string): T;
                                 inputFile = ""): seq[T] =
  let inputRaw = getInput(day, year, inputFile)
  for line in splitLines(inputRaw): result.add line.parser

proc getInputWithParser*[T](day: AocDay, year: AocYear; parser: proc (input: string): T;
                            inputFile = ""): T =
  let inputRaw = getInput(day, year, inputFile)
  result = inputRaw.parser

#TODO: Add automatic sending (and checking) of answers and make it easy to integrate with cligen arguments
#TODO: Separate exporting of commonly used libraries into some categories and put them in their own files and rename this file to aocUtils or something
