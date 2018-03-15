-- ve | 04.03.2018
-- By daelvn
-- Reads text from a file and returns a handle

-- Object
local TextReader   = {}
TextReader.__index = TextReader
-- Create new TextReader
function TextReader:new (file, o)
  o = o or {
    file   = file,
    lines  = {}
  }
  setmetatable (o, self)
  return o
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
  local obj = TextReader:new "test.txt"
  if not obj then error "ve/textReader:new! Error creating object" end

  -- :wopen
  deb ":wopen"
  obj:wopen ()
  if not obj.lines  then error "ve/textReader:wopen! Error reading lines"  end
  if not obj.handle then error "ve/textReader:wopen! Error opening handle" end

  -- :ropen
  deb ":ropen"
  obj:ropen ()
  if not obj.lines  then error "ve/textReader:ropen! Error reading lines"  end
  if not obj.handle then error "ve/textReader:ropen! Error opening handle" end

  -- :readAll
  deb ":readAll"
  obj:ropen ()
  local str = obj:readAll ()
  if not str then error "ve/textReader:readAll! Could not read file" end

  -- :writeAll
  deb ":writeAll"
  obj:wopen ()
  obj:writeAll ("Example data.")
  if not obj.lines  then error "ve/textReader:writeAll! Error reading lines"  end
  if not obj.handle then error "ve/textReader:writeAll! Error writing to file" end

  -- :flush
  deb ":flush"
  obj:flush ()
  if not obj.handle then error "ve/textReader:flush! Error opening handle" end

  -- @reopen
  deb "@reopen"
  obj:close ()
  if obj.handle then error "ve/textReader@reopen! Error closing handle" end
  obj:wopen ()
  if not obj.lines  then error "ve/textReader@reopen! Error reading lines (w)"  end
  if not obj.handle then error "ve/textReader@reopen! Error opening handle (w)" end

  -- :writeLines
  deb ":writeLines"
  obj:writeLines ()
  if not obj.handle then error "ve/textReader:writeLines! Error writing to file handle" end

  -- :write
  deb ":write"
  obj:write (1, 3, "plo")
  if not obj.handle then error "ve/textReader:write! Error writing to file" end

  -- @flush
  deb "@flush"
  obj:flush ()
  if not obj.handle then error "ve/textReader@flush! Error flushing" end
  
  -- :close
  deb ":close"
  obj:close ()
  if obj.handle then error "ve/textReader:close! Error closing handle" end

  return true end
}

-- Return namespace
return TextReader



