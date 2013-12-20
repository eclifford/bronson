#
# grunt-contrib-connect
# https://github.com/gruntjs/grunt-contrib-connect
#
module.exports = (grunt) ->
  options:
    port: grunt.settings.server.port
    livereload: grunt.settings.server.livereload_port
    hostname: grunt.settings.server.hostname

  livereload:
    options:
      open: grunt.settings.server.open
      base: [
        '<%= grunt.settings.paths.tempDir %>'
        '<%= grunt.settings.paths.basePath %>'
      ]

  dist:
    options:
      open: grunt.settings.server.open
      base: '<%= grunt.settings.paths.buildDir %>'
