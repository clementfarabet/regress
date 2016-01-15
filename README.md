Regress
=======

A very simple regression test package.

```lua
local test = require 'regress'

test {
   test1 = function()
      test.mustBeTrue(a == b, 'a should == b')
   end,

   test2 = function()
      test.shouldBeTrue(a == b, 'a should == b')
   end,
}
```
