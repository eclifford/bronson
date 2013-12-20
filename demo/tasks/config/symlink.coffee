#
# grunt-contrib-symlink
# https://github.com/gruntjs/grunt-contrib-symlink
#
module.exports = (grunt) ->
  options:
    force: true
    overwrite: true

  expanded:
    files: [
      expand: true
      cwd: '<%= grunt.settings.paths.basePath %>/vendor/bower_components'
      src: ['*']
      dest: '<%= grunt.settings.paths.tempDir %>/vendor/bower_components'
    ]
