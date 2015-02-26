# Description:
#   Load script recursively
# Dependences:
#   "glob": "~3.1.20"
# Link:
#   http://sui.hateblo.jp/entry/2013/02/28/050014

Path = require "path"
Glob = require "glob"

module.exports = (robot) ->
  dirs = Glob.sync(__dirname+"/**/*/")
  for dir in dirs
    robot.load dir
