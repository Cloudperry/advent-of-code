import tables, sequtils, strutils, strformat, math
import ../common

type
  ConwayCubeLayer = seq[seq[bool]] #x-z plane in 3D space, when x and z are both horizontal
  ConwayCubeSpace = seq[ConwayCubeLayer] #3D space where first index is y (vertical axis), second i is x and third is z
  LayerStateString = seq[string]

const
  #Can't add new rows/columns/layers before 0 without moving everything, so I will just make the initial 3D space very big and put input.txt in the center
  spaceSize = 100
  charToBoolState = {
    '.': false,
    '#': true
  }.toTable
  boolStateToChar = {
    false: '.',
    true: '#'
  }.toTable
 #[ DEBUG STUFF
 proc `$`(conwayCubeLayer: ConwayCubeLayer): string =
 for i, row in conwayCubeLayer:
 result.add(row.mapIt(boolStateToChar[it]).join)
 if i != conwayCubeLayer.high: result.add('\n')

 #proc `$`(conwayCubeSpace: ConwayCubeSpace): string =
 for y, layer in conwayCubeSpace:
 result.add(fmt"y={y}{'\n'}{layer}")
 if y != conwayCubeSpace.high: result.add('\n')
 ]#
proc newEmptyConwayCubeLayer(size: int): ConwayCubeLayer =
  let inactiveRow = newSeq[bool](size)
  result = newSeq[seq[bool]](size)
  for emptyRow in result.mitems:
    emptyRow = inactiveRow

proc charsToConwayCubeSpace(layerState: LayerStateString): ConwayCubeSpace =
  let center = (spaceSize / 2).ceil.int
  for i in 1 .. spaceSize: result.add(newEmptyConwayCubeLayer(spaceSize))
  for x, xRow in layerState:
    for z, value in xRow:
      result[center][center - layerState.len div 2 + x][center -
                xRow.len div 2 + z] = charToBoolState[value]

proc countAdjacentActiveCubes(conwayCubeSpace: ConwayCubeSpace; x, y, z: int): int =
  for checkY in y - 1 .. y + 1:
    block yIter:
      for checkX in x - 1 .. x + 1:
        block xIter:
          for checkZ in z - 1 .. z + 1:
            block zIter:
              if not (checkX == x and checkY == y and checkZ == z):
                if checkY notin 0 .. conwayCubeSpace.high: break yIter
                if checkX notin 0 .. conwayCubeSpace[0].high: break xIter
                if checkZ notin 0 .. conwayCubeSpace[0][0].high: break zIter
                #echo fmt"checking {checkX}, {checkY}, {checkZ}"
                if conwayCubeSpace[checkY][checkX][checkZ]:
                  #echo fmt"found active at {checkX}, {checkY}, {checkZ}"
                  result += 1

proc getNextConwayCubesIter(conwayCubeSpace: ConwayCubeSpace): ConwayCubeSpace =
  result = conwayCubeSpace
  for y, layer in conwayCubeSpace:
    for x, xRow in layer:
      for z, state in xRow:
        let adjacentCubes = countAdjacentActiveCubes(conwayCubeSpace, x, y, z)
        if state and adjacentCubes notin {2, 3}:
          result[y][x][z] = false
        elif not state and adjacentCubes == 3:
          result[y][x][z] = true

let input = getInput()
var conwayCubeSpace = charsToConwayCubeSpace(input)
for i in 1 .. 6: conwayCubeSpace = getNextConwayCubesIter(conwayCubeSpace)

var cubeCount: int
for y in conwayCubeSpace:
  for x in y:
    for z in x:
      if z: cubeCount += 1
echo cubeCount
