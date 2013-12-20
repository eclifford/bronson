#
# grunt-concurrent
# https://github.com/sindresorhus/grunt-concurrent
#
module.exports = (grunt) ->
  dev: [
    'sass'
    'coffee'
    'copy:assets'
    'includereplace'
  ]



