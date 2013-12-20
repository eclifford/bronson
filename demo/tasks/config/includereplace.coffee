#
# grunt-include-replace
# https://github.com/alanshaw/grunt-include-replace
#
module.exports = (grunt) ->
  options:
    includesDir: '<%= grunt.settings.paths.basePath %>/common/partials'
  dev: 
    expand: true
    cwd: '<%= grunt.settings.paths.basePath %>'
    src: ['index.html', 'pages/**/*.html']
    dest: '<%= grunt.settings.paths.tempDir %>'
