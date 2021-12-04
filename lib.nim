import os, httpclient
import math, strutils, strformat, strscans, sequtils, tables, sets, hashes, times
import regex, bitty
export math, strutils, strformat, strscans, sequtils, tables, sets, hashes, times
export regex, bitty

let currentYear = now().year

proc getInputIfNotDownloaded*(day: Natural; year = currentYear) =
  if not fileExists("input.txt"):
    var client = newHttpClient()
    let sessionCookie = readFile("../sessionCookie").strip
    client.headers = newHttpHeaders({ "Cookie": "session={sessionCookie}" })
    echo fmt"downloading https://adventofcode.com/{year}/day/{day}/input with {sessionCookie}"
    client.downloadFile(fmt"https://adventofcode.com/{year}/day/{day}/input", "input.txt")

proc getInputLines*[T](day: Natural; year = currentYear): seq[T] =
  getInputIfNotDownloaded(day, year)
  for line in lines("input.txt"): result.add line

proc getInputLinesWithParser*[T](day: Natural; parseWith: proc (input: string): T; year = currentYear): seq[T] =
  getInputIfNotDownloaded(day, year)
  for line in lines("input.txt"):
    result.add line.parseWith

proc getInputWithParser*[T](day: Natural; parseWith: proc (input: string): T; year = currentYear): T =
  getInputIfNotDownloaded(day, year)
  readFile("input.txt").parseWith
