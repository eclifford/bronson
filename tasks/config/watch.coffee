#
# grunt-contrib-watch
# https://github.com/gruntjs/grunt-contrib-watch
#
module.exports =
  options :
    spawn: false
    livereload: '<%= connect.options.livereload %>'

  coffee:
    files: ['**/*.coffee', '!vendor/**/*']
    tasks: ['coffeelint', 'coffee:dev', 'karma:unit:run']

  sass:
    files: ['<%= options.basePath %>/**/*.{scss,sass}', '!vendor/**/*'],
    tasks: ['sass:dev']

  assets:
    files: ['<%= options.basePath %>/**/*.html', '!vendor/**/*']
