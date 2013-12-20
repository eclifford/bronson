#
# grunt-contrib-watch
# https://github.com/gruntjs/grunt-contrib-watch
#
module.exports = (grunt) ->
  options :
    spawn: false
    livereload: grunt.settings.server.livereload

  coffee:
    files: ['**/*.coffee', '!vendor/**/*']
    tasks: if grunt.settings.project.linting then ['coffeelint', 'coffee:dev'] else ['coffee:dev']

  sass:
    files: ['<%= grunt.settings.paths.basePath %>/**/*.{scss,sass}', '!vendor/**/*'],
    tasks: ['sass:dev']

  assets:
    files: ['<%= grunt.settings.paths.basePath %>/**/*.html', '!vendor/**/*']
    tasks: ['includereplace']
