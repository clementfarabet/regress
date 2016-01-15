-- Warning function
local lastWarning
local warning = function(msg)
   lastWarning = msg
end

-- Symbols
local colors = require('trepl.colorize')
local success = colors.green('✔')
local failure = colors.red('✗')
local warning = colors.magenta('?')

-- Run tests:
local run = function(tests)
   -- Options/data:
   local errors = {}
   local warnings = {}

   -- Name of calling func:
   local fpath = debug.getinfo(3).source:gsub('@','')

   -- Run tests:
   print('Running tests for file ['..fpath..']:')
   local N = 0
   io.write('[')
   for _ in pairs(tests) do
      io.write('.')
   end
   io.write(']\r[')
   io.flush()
   for name,test in pairs(tests) do
      local ok,err = xpcall(test, debug.traceback)
      if ok then
         if lastWarning then
            io.write(warning) io.flush()
            warnings[name] = lastWarning
            lastWarning = nil
         else
            io.write(success) io.flush()
         end
      else
         io.write(failure) io.flush()
         errors[name] = err
         N = N + 1
      end
   end
   print('')

   -- Conclusion
   for name,result in pairs(errors) do
      print(colors.red('test['..name..'] failed - ' .. result))
   end
   for name,result in pairs(warnings) do
      print(colors.magenta('test['..name..'] warning - ' .. result))
   end

   -- Exit with error code?
   if N > 0 then
      error()
   end
end

-- Return lib:
local lib = {
   run = run,
   ascii = function()
      -- go to raw ascii
      success = 'v'
      failure = 'x'
      warning = '?'
   end,
   mustExist = function(data, message)
      if not data then
         error(message)
      end
   end,
   mustBeTrue = function(data, message)
      if data ~= true then
         error(message)
      end
   end,
   mustBeFalse = function(data, message)
      if data ~= false then
         error(message)
      end
   end,
   shouldExist = function(data, message)
      if not data then
         warning(message)
      end
   end,
   shouldBeTrue = function(data, message)
      if data ~= true then
         warning(message)
      end
   end,
   shouldBeFalse = function(data, message)
      if data ~= false then
         warning(message)
      end
   end,
}

setmetatable(lib, {
   __call = function(self,tests)
      lib.run(tests)
   end
})

return lib
