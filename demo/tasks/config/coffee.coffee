#
# grunt-contrib-coffee
# https://github.com/gruntjs/grunt-contrib-coffee
#
module.exports = (grunt) ->
  dev:
    expand: true
    cwd: "<%= grunt.settings.paths.basePath %>"
    src: ["**/*.coffee", "!**/vendor/**/*.coffee"]
    dest: "<%= grunt.settings.paths.tempDir %>"
    ext: ".js"
