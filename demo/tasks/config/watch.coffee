#
# grunt-contrib-watch
# https://github.com/gruntjs/grunt-contrib-watch
#
module.exports = (grunt) ->
  options :
    spawn: false
    livereload: grunt.settings.server.livereload

  coffee:
    files: ['<%= grunt.settings.paths.basePath %>/modules/**/*.coffee', 'main.coffee']
    tasks: if grunt.settings.project.linting then ['coffeelint', 'coffee:dev'] else ['coffee:dev']

  sass:
    files: ['<%= grunt.settings.paths.basePath %>/modules/**/*.{scss,sass}', '<%= grunt.settings.paths.basePath %>/main.{scss,sass}'],
    tasks: ['sass:dev']

  assets:
    files: ['<%= grunt.settings.paths.basePath %>/pages/**/*.html', '<%= grunt.settings.paths.basePath %>/index.html']
    tasks: ['includereplace']
