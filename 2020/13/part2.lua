function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t, cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

local filename = arg[1] or "input.txt"
local input = lines_from(filename)
local busIds = split(input[2], ',')
local busIdFunctionsOfTimestamp = {}
for i, busId in ipairs(busIds) do
   local offset = i - 1
   if busId ~= 'x' then
      local busIdInt = tonumber(busId)
      local function busIdFunctionOfTimestamp(x)
         if offset > 0 then
            return x / busIdInt + offset / busIdInt
         else
            return x / busIdInt
         end
      end
      busIdFunctionsOfTimestamp[busIdInt] = busIdFunctionOfTimestamp
   end
end

for i = 100000000000000, 10000000000000000, 1 do
   print(i)
   local valuesAreInts = true
   for _, f in pairs(busIdFunctionsOfTimestamp) do
      local value = f(i)
      if value ~= math.floor(value) then
         valuesAreInts = not valuesAreInts
         break
      end
   end
   if valuesAreInts == true then do
      print(i)
      break
   end
end
end --MITÄ IHMETTÄ MIKS TÄÄ ON TÄSSÄ
