#
# grunt-coffeelint
# https://github.com/vojtajina/grunt-coffeelint
#
module.exports = (grunt) ->
  options:
    'max_line_length':
      'level': 'ignore'
  app: [
    '<%= grunt.settings.paths.basePath %>/**/*.coffee'
  ]
