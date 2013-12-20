#
# grunt-contrib-clean
# https://github.com/gruntjs/grunt-contrib-clean
#
module.exports = (grunt) ->
  options:
    force: true # watch yourself there be dragons

  dist: [
    "<%= grunt.settings.paths.tempDir %>",
    "<%= grunt.settings.paths.buildDir %>"
  ]
  server: [
    "<%= grunt.settings.paths.tempDir %>"
  ]
