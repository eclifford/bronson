#
# Build task
# Build deployment artifacts
#
module.exports = (grunt) ->
  grunt.registerTask 'build', [
    'clean:dist'
    'concurrent:dev'
    'symlink'
    'requirejs'
  ]

