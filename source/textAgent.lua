-- ve | 04.03.2018
-- By daelvn
-- Agent for acting on TextReader objects

-- Namespace
local TextAgent = {}

-- Libraries
local diff = require "core.diff"

-- Create a new TextAgent
function TextAgent:new (reader, o)
  o = o or {
    reader = reader
  }
  setmetatable (self, o)
  self.__index = self
  return o
end

--[[
TextAgent  Function
===========================================================================
Verb       Function
---------------------------------------------------------------------------
a          Undo
Number+c   Move to tab number
d+Object   Takes an object and deletes/cuts it.
Number+g   Goes to a line number.
i          Goes into insert mode.
m+Mark     Marks a position in a mark register.
o          Pastes the cut clipboard contents.
p          Pastes the visual/copy clipboard contents.
q+Macro    Records a macro and stores it.
r+Char     Replaces the character in the current position with another.
s          Redo.
Number+t   Opens a tab number.
v          Goes into Visual mode.
x          Goes to the next result of a search.
y+Object   Takes an object and copies it.
z          Goes to the previous result of a search.
J          Joins the line on which the cursor is with the line below.
Q+Macro    Runs a macro.
Object     Pressing an object key alone will take you to the position. For
           example, using the '1' SoL object will take you to the start of
           the line and such.
---------------------------------------------------------------------------
Visual     Function
---------------------------------------------------------------------------
c          Copy selected text.
d          Delete selected text.
s+Mark     Selects from the current cursor position to a Mark.
x          Cut selected text.
D          Deselects all text.
S+Register Stores selected text into register.
---------------------------------------------------------------------------
Object     Function
---------------------------------------------------------------------------
e          End of a word.
h          Character to the left of the cursor.
j          Character below the cursor.
k          Character above the cursor.
l          Character to the right of the cursor.
w          Start of a word.
E          (Backwards) End of a word.
F          End of the document.
H          Start of the document.
W          (Backwards) Start of a word.
.          Whole word.
-          Whole line.
'+Mark     Mark register.
"+Register Register.
{          Start of paragraph.
}          End of paragraph.
1          Start of line.
2          End of line.
]]--

---- Verbs
TextAgent.verb = {}
--- Undo & Redo
-- Wrapper around TextReader:writeAll()
function TextAgent:writeAll () end
function TextAgent.verb.undo () end










