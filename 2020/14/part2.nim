import strutils, strscans, math, tables
import ../common

let input = getInput()

var
  memory: Table[int, int]
  currentMask: string
for lineN, line in input:
  var address, value: int
  discard line.scanf("mask = $+", currentMask)
  if line.scanf("mem[$i] = $i", address, value):
    #echo "address: ", address.toBin(36)
    var writeAddrs = @[""]
    for i, bitChar in address.toBin(36):
      if currentMask[i] == '0':
        writeAddrs[0] &= bitChar
      else:
        writeAddrs[0] &= currentMask[i]
    #Code below finds all the memory addresses, that need to be written
    proc getPermsOfFloatingBit(address: string, floatingBitI: int): seq[string] =
      result.add(address[0 ..< floatingBitI] & '0' & address[floatingBitI + 1 .. ^1])
      result.add(address[0 ..< floatingBitI] & '1' & address[floatingBitI + 1 .. ^1])
    if 'X' in writeAddrs[0]:
      #echo "mask: ", currentMask
      var currentAddrI: int
      while true:
        let floatingBitI = writeAddrs[currentAddrI].find('X')
        if floatingBitI == -1: break
        writeAddrs.add(getPermsOfFloatingBit(writeAddrs[currentAddrI], floatingBitI))
        currentAddrI += 1
      #Code below writes to the addresses or address
      let finalPermsN = 2 ^ writeAddrs[0].count('X')
      #echo "permutations: " writeAddrs[^finalPermutationsN .. ^1]
      for address in writeAddrs[^finalPermsN .. ^1]:
        memory[address.parseBinInt] = value
    else:
      memory[writeAddrs[0].parseBinInt] = value

var valuesInMemory: seq[int]
for value in memory.values: valuesInMemory.add(value)
echo sum(valuesInMemory)
