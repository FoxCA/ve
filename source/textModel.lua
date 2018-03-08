-- ve | 04.03.2018
-- By daelvn
-- Wrapper around textReader that works in changes.

-- Namespace
local TextModel = {}

-- New
function TextModel:new (textReader, o)
  o = o or {
    reader = textReader,
    model  = {},
    edits  = {},
  }
  setmetatable (self, o)
  self.__index = self
  return o
end

-- Initialize
function TextModel:initialize ()
  if not self.reader.ropen (self.reader.file) then return false end
  self.model = {
    lines = self.reader.lines,
    count = {}
  }
  -- Initialize line-based character count
  for n,l in ipairs (self.model.lines) do
    self.model.count[n] = l:len()
  end
end

-- NOTE: Actions taken in Normal mode are registered inmediately in the
--       edit stack. In Insert mode, a configurable timer specifies how
--       often the edits are registered.

-- Inserts a string in the Model at the line and column specified
function TextModel:write (ln, col, str)
  -- getOld
  local ostr                = self.model.lines[ln]:sub(col, col+str:len())
  self.edits[#self.edits+1] = {ln=ln,col=col,str=ostr}
end

-- textAgentrObject
