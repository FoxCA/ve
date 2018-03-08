-- ve | 06.03.2018
-- By daelvn
-- Testing functions

return function (arg)
  return function (filename)
    return function (suite)
      if arg == filename then
        print ("ve/"..filename:sub(-4))
        return suite ()
      end
    end
  end
end
