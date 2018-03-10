-- ve | 06.03.2018
-- By daelvn
-- Testing functions

return {test=function (t)
          if t.arg == t.flag then print ("ve/"..t.module); return t.suite () end end,
        iterate=function (t)
          for k,v in ipairs(t) do print(k,v) end end}
