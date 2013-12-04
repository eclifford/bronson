#
# grunt-coffeelint
# https://github.com/vojtajina/grunt-coffeelint
#
module.exports =
  options:
    'max_line_length':
      'level': 'ignore'
  app: [
    '<%= options.basePath %>/**/*.coffee'
  ]
