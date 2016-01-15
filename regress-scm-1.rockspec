package = "regress"
version = "scm-1"

source = {
   url = "-",
   branch = "master",
}

description = {
   summary = "Regression tests made easy",
   homepage = "-",
   license = "Twitter"
}

dependencies = {
   "torch >= 7.0",
   "trepl",
}

build = {
   type = "builtin",
   modules = {
      ['regress.init'] = 'init.lua',
   },
}
