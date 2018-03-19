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
  return setmetatable (o or {
    base     = nil,
    branches = setmetatable ({}, {__call=function(t,s)return t[s]end}),
    current  = nil,
  }, self)
end

-- TextState & TextBase --
local TextState   = {}
TextState.__index = TextState
local TextBase    = {}
TextBase.__index  = TextBase

-- New
function TextState:new (ln, col, str, o)
  return setmetatable (o or {
    line   = ln,
    column = col,
    predit = str,
  }, self)
end
-- New (base)
function TextBase:new (text, o)
  return setmetatable( o or {
    text = text,
  }, self)
end

-- TextActionBranch --
local TextActionBranch   = {}
TextActionBranch.__index = TextActionBranch

-- New
local _branchCount = 0
function TextActionBranch:new (parent, name, pointer, line, base, o)
  _branchCount = _branchCount + 1
  return setmetatable (o or {
    parent  = parent  or "$none",
    name    = name    or ("fork-"..tostring(_branchCount)),
    pointer = pointer or "1a",
    line    = line    or {},
    base    = base    or TextBase:new("")
  }, self)
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
  return setmetatable (o or {
    last       = last or "$none",
    index      = index or incridx,
    hasPointer = hasPointer or false,
    state      = textState,
    forks      = {}
  }, self)
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
  self.line [0] = textBase
  self.base     = self.line [0] 
end
-- TODO :get
function TextActionBranch:get (property)
  if     property == "base"  then return self.base
  elseif property == "first" then return self.line [1] 
  elseif property == "last"  then return self.line [#self.line] -- This can return the base
  elseif property == "*"     then 
    for k,v in pairs (self.line) do
      if v.hasPointer == true then return v end
    end
  end
  --elseif property == "-" then return - end
end
-- TODO :act
function TextActionBranch:act (textState)
  -- setData
  local lastAction = self:get "last" -- Last can be Base, as well
  -- createTextAction
  local action     = TextAction:new (
    -- last
    lastAction,
    -- textState
    textState,
    -- index
    lastAction.index and _incrIndex (lastAction.index) or _incrIndex (base.index),
    -- hasPointer (we have to remove the pointer from lastAction)
    true
  )
  -- removeOldPointer
  self:get "*".hasPointer  = false
  -- submitTextAction
  self.line [#self.line+1] = action
  -- Return
  return true
end
-- TODO :fork
function TextActionBranch:fork (textActionBranch)
  -- getPointedAction
  local action = self:get "*"
  -- createFork
  local fork   = TextActionBranch:new () 
  action.forks [#action.forks+1] = textActionBranch.name
end
-- TODO :on
-- TODO :over
-- TODO :back
-- TODO :undo
-- TODO :oundo

