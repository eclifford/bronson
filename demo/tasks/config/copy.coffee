#
# grunt-contrib-copy
# https://github.com/gruntjs/grunt-contrib-copy
#
module.exports = (grunt) ->
  assets:
    expand: true
    dot: true
    cwd: '<%= grunt.settings.paths.basePath %>'
    src: ['**/*.{jsp,js,css,woff,ttf,svg,jpeg,jpg,html}', '!**/vendor/bower_components/**/*']
    dest: '<%= grunt.settings.paths.tempDir %>'

