-- ve | 15.03.2018
-- By daelvn
-- Edit tree managing

-- Namespace
local TextActions = {}

-- TextActionTree --
local TextActionTree   = {}
TextActionTree.__index = TextActionTree

-- New
function TextActionTree:new (o)
  o = o or {
    base     = nil,
    branches = {},
    current  = nil,
  }
  local bm = {__call=function(t,s)return t[s]end}
  setmetatable (o.branches, bm)
  setmetatable (o, self)
  return o
end

-- TextState & TextBase --
local TextState   = {}
TextState.__index = TextState
local TextBase    = {}
TextBase.__index  = TextBase

-- New
function TextState:new (ln, col, str, o)
  o = o or {
    line   = ln,
    column = col,
    predit = str,
  }
  setmetatable (o, self)
  return o
end
-- New (base)
function TextBase:new (text, o)
  o = o or {
    text = text,
  }
  setmetatable (o, self)
  return o
end

-- TextActionBranch --
local TextActionBranch   = {}
TextActionBranch.__index = TextActionBranch

-- New
local _branchCount = 0
function TextActionBranch:new (parent, name, pointer, line, base, o)
  _branchCount = _branchCount + 1
  o = o or {
    parent  = parent  or "$none",
    name    = name    or ("fork-"..tostring(_branchCount)),
    pointer = pointer or "1a",
    line    = line    or {},
    base    = base    or TextBase:new("")
  }
  setmetatable (o, self)
  return o
end

-- TextAction --
local TextAction   = {}
TextAction.__index = TextAction

-- Increments index of a TextAction
local function _incrIndex (idx, isFork)
  -- 31c -> (31 + 1) .. c -> 32c
  if isFork then idx = idx:gsub (
    idx:match "%a$",
    ("abcdefghijklmnopqrstuvwxyz"):match ((idx:match "%a$").."(.)")
  ) return idx end
  return tostring (tonumber (idx:match "%d+") + 1) .. idx:match "%a$"
end

-- New
function TextAction:new (last, textState, index, hasPointer, o, isFork)
  local incridx = _incrIndex (last and last.index or "0a", isFork)
  o = o or {
    last       = last or "$none",
    index      = index or incridx,
    hasPointer = hasPointer or false,
    state      = textState,
    forks      = {}
  }
  setmetatable (o, self)
  return o
end

-- TextActionTree functions --
--- Base
-- Sets the base branch for the TextActionTree
function TextActionTree:base (textActionBranch)
  self.base = textActionBranch.name
end
-- Returns the base TextActionBranch
function TextActionTree:getBase ()
  return self.branches [self.base] or false
end

--- Global managing
-- Removes all branches
function TextActionTree:removeAll ()
  self.branches = {}
  return true
end

--- Individual managing
-- Adds a branch
function TextActionTree:branch (textActionBranch)
  self.branches [textActionBranch.name] = textActionBranch
  return true
end
-- Removes a branch
function TextActionTree:cut (textActionBranch)
  self.branches [textActionBranch.name] = nil
  return true
end
-- Renames a branch
function TextActionTree:rename (textActionBranch, newname)
  local oldname           = textActionBranch.name
  textActionBranch.name   = newname
  self.branches [newname] = self.branches [oldname]
  self.branches [oldname] = nil
  return true
end

--- Moving branches
-- Checks out a branch
function TextActionTree:on (textActionBranch, index)
  -- tree:on (tree.branches "fork-2", )
  -- tree:on (tree.branches [tree.current])
  self.current = textActionBranch.name
  return true
end

-- TextState functions --
-- Place edit at line
function TextState:place (line)
  local part1, part2 = line:sub (1, self.col), line:sub (self.predit:len())
  return part1..self.predit..part2
end

-- TextAction functions --
-- Fork the action
function TextAction:fork ()
  return self:new (self, self.state, nil, false, nil, true)
end

-- TextActionBranch functions --
-- TODO :initialize
function TextActionBranch:initialize (textBase)
  self.base     = textBase
  self.line [0] = textBase
end
-- TODO :get
function TextActionBranch:get (property)
  if     property == "base"  then return self.base
  elseif property == "first" then return self.line [1] 
  elseif property == "last"  then return self.line [#self.line]
  elseif property == "*"     then 
    for k,v in pairs (self.line) do
      if v.hasPointer == true then return v
    end
  end
  --elseif property == "-" then return - end
end
-- TODO :act
function TextActionBranch:act (textState)
  -- setData
  local lastAction = self:get "last"
  local base       = self:get "base"
  -- createTextAction
  local ta         = TextAction:new (
    -- last
    lastAction or base,
    -- textState
    textState,
    -- index
    lastAction and _incrIndex (lastAction.index) or _incrIndex (base.index),
    -- hasPointer (we have to remove the pointer from lastAction)
    true
  )
  -- removeOldPointer
  (self:get "*").hasPointer = false
  -- submitTextAction
  self.line [#self.line+1] = ta
  --
  return true
end
-- TODO :on
-- TODO :fork
-- TODO :over
-- TODO :back
-- TODO :undo
-- TODO :oundo

