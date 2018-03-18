-- ve | 04.03.2018
-- By daelvn
-- Wrapper around textReader that works in changes.

-- Namespace
local TextModel   = {}
TextModel.__index = TextModel

-- New
function TextModel:new (textReader, o)
  return setmetatable (o or {
    reader = textReader,
    model  = {},
    edits  = {},
  }, self)
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
    self.model.count[n] = l:len ()
  end
end

-- NOTE: Actions taken in Normal mode are registered inmediately in the
--       edit stack. In Insert mode, a configurable timer specifies how
--       often the edits are registered.

-- Inserts a string in the Model at the line and column specified
function TextModel:write (ln, col, str)
  -- getOld
  local ostr                = self.model.lines[ln]
  self.edits[#self.edits+1] = {ln=ln,str=ostr} -- TextState
  -- editText
  self.reader:wopen ()
  self.reader:write (ln,col,str)
end

-- Registers a TextState in the edit register
function TextModel:register (TextState) self.edits[#self.edits+1] = TextState end
