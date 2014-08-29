#
# grunt-contrib-coffee
# https://github.com/gruntjs/grunt-contrib-coffee
#
module.exports = (grunt) ->
  dev:
    expand: true
    cwd: "<%= grunt.settings.paths.basePath %>"
    src: ["modules/**/*.coffee", "main.coffee", "common.coffee"]
    dest: "<%= grunt.settings.paths.tempDir %>"
    ext: ".js"
