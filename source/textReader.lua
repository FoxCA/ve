-- ve | 04.03.2018
-- By daelvn
-- Reads text from a file and returns a handle

-- Object
local TextReader   = {}
TextReader.__index = TextReader
-- Create new TextReader
function TextReader:new (file, o)
  return setmetatable (o or {
    file  = file,
    lines = {},
  }, self)
end

-- Opens the handle
function TextReader:ropen ()
  local file = self.file
  -- exists?
  if not pcall (io.lines (file)) then
    io.open (file, "w"):close()
  end
  -- readLines
  local lc = 1
  for line in io.lines (file) do
    self.lines[lc] = line
    lc = lc + 1
  end
  -- closeLast
  if self.handle then self.handle:close () end
  self.handle = nil
  -- tryOpen
  local tryOpen = io.open (file, "r")
  if not tryOpen then return false end
  tryOpen:close ()
  -- fileOpen
  self.handle = io.open (file, "r")
end
function TextReader:wopen ()
  local file = self.file
  -- exists?
  if not pcall (io.lines (file)) then
    io.open (file, "w"):close()
  end
  -- readLines
  local lc = 1
  for line in io.lines (file) do
    self.lines[lc] = line
    lc = lc + 1
  end
  -- closeLast
  if self.handle then self.handle:close () end
  self.handle = nil
  -- tryOpen
  local tryOpen = io.open (file, "w")
  if not tryOpen then return false end
  tryOpen:close ()
  -- fileOpen
  self.handle = io.open (file, "w")
end

-- Close the handle
function TextReader:close ()
  self.handle:close()
  self.handle = nil
end

-- Get full document string
function TextReader:readAll ()
  return table.concat (self.lines, "\n")
end

-- Rewrite file
function TextReader:writeAll (str)
  -- fileWrite
  self.handle:write (str)
  self.handle:flush ()
end

-- Write lines to file
function TextReader:writeLines ()
  self.handle:write (self:readAll ())
  self.handle:flush ()
end

-- Write at position
function TextReader:write (ln, col, str)
  -- lineEdit
  local line  = self.lines[ln]
  local first = line:sub (1, col)
  local last  = line:sub (   col)
  self.lines[ln] = first..str..last
  -- fileWrite
  self.handle:write (self:readAll ())
end

-- Flush
function TextReader:flush ()
  self.handle:flush ()
end

-- Return namespace
return TextReader



