#
# Default Task
# Default task for watching, compiling and running tests
#
module.exports = (grunt) ->
  grunt.registerTask 'default',
  [
    'clean'
    'concurrent:dev'
    # 'copy'
    'connect:livereload'
    'watch'
  ]
