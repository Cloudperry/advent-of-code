import ../common

let input = getInput()

proc getLowerHalf(s: Slice): Slice =
  if s.len mod 2 == 0:
    return s.a .. s.a + (s.b - s.a) div 2
  else:
    raise newException(ValueError, "the given range should have an even number of elements")

proc getUpperHalf(s: Slice): Slice =
  if s.len mod 2 == 0:
    return s.a + s.len div 2 .. s.b
  else:
    raise newException(ValueError, "the given range should have an even number of elements")

var highestSeatID: int
for line in input:
  var
    seatFrontToBackRange = 0..127
    seatLeftToRightRange = 0..7
  for i, char in line:
    if char == 'F':
      seatFrontToBackRange = seatFrontToBackRange.getLowerHalf()
    elif char == 'B':
      seatFrontToBackRange = seatFrontToBackRange.getUpperHalf()
    elif char == 'L':
      seatLeftToRightRange = seatLeftToRightRange.getLowerHalf()
    elif char == 'R':
      seatLeftToRightRange = seatLeftToRightRange.getUpperHalf()
  let (row, col) = (seatFrontToBackRange.a, seatLeftToRightRange.a)
  let seatID = row * 8 + col
  if seatID > highestSeatID: highestSeatID = seatID

echo highestSeatID
