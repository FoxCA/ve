-- ve | 04.03.2018
-- By daelvn
-- Reads text from a file and returns a handle

-- Object
local TextReader = {}

-- Create new TextReader
function TextReader:new (file, o)
  o = o or {
    file   = file,
    lines  = {},
    handle = {},
  }
  setmetatable (self, o)
  self.__index = self
  return o
end

-- Opens the handle
function TextReader:ropen ()
  local file = self.file
  -- closeLast
  if self.handle.close then self.handle:close () end
  self.handle = nil
  -- tryOpen
  local tryOpen = io.open (file, "r")
  if not tryOpen then return false end
  tryOpen:close ()
  -- fileOpen
  self.handle = io.open (file, "r")
  self.file   = file
  local lc = 1
  for line in io.lines (file) do
    self.lines[lc] = line
    lc = lc + 1
  end
end
function TextReader:wopen ()
  local file = self.file
  -- closeLast
  if self.handle.close then self.handle:close () end
  self.handle = nil
  -- tryOpen
  local tryOpen = io.open (file, "w")
  if not tryOpen then return false end
  tryOpen:close ()
  -- fileOpen
  self.handle = io.open (file, "w")
  self.file   = file
  local lc = 1
  for line in io.lines (file) do
    self.lines[lc] = line
    lc = lc + 1
  end
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

-- Tests
local core_test     = require "core.test"
local test, iterate = core_test.test, core_test.iterate
local deb           = print
test{
  arg      = arg[1],
  flag     = "-test",
  module   = "textReader",
  suite    = function ()
  -- :new
  deb ":new"
  local obj = TextReader:new ("test.txt"); print(type(obj))
  if not obj then return false end

  -- :ropen
  deb ":ropen"
  obj:ropen ()
  if (not obj.lines) or (not obj.handle) then return false end

  -- :wopen
  deb ":wopen"
  obj:wopen ()
  if not obj.handle then return false end

  -- :readAll
  deb ":readAll"
  obj:ropen ()
  local str = obj:readAll ()
  if not str then return false end

  -- :writeAll
  deb ":writeAll"
  obj:wopen ()
  obj:writeAll ("Example data.")
  if not obj.handle then return false end

  -- :writeLines
  deb ":writeLines"
  obj:writeLines ()
  if not obj.handle then return false end

  -- :write
  deb ":write"
  obj:write (1, 3, "plo")

  -- :flush
  deb ":write"
  obj:flush ()
  if not obj.handle then return false end
  
  -- :close
  deb ":close"
  obj:close ()
  if obj.handle then return false end

  return true end
}

-- Return namespace
return TextReader



