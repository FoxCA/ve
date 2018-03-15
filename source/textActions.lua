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

-- TextState --
local TextState   = {}
TextState.__index = TextState

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

-- TextActionBranch --
local TextActionBranch   = {}
TextActionBranch.__index = TextActionBranch

-- New
local _branchCount = 0
function TextActionBranch:new (parent, name, pointer, line, o)
  _branchCount = _branchCount + 1
  o = o or {
    parent  = parent,
    name    = name    or ("fork-"..tostring(_branchCount)),
    pointer = pointer or "0a",
    line    = line    or {},
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
    last       = last,
    index      = index or incridx,
    hasPointer = hasPointer or false,
    state      = textState
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
-- TODO :act
function TextActionBranch:act (textAction)
end
-- TODO :on
-- TODO :fork
-- TODO :over
-- TODO :back
-- TODO :undo
-- TODO :oundo

