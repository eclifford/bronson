module.exports = (grunt) ->
  grunt.registerTask 'test', (target) ->
    if target is 'unit'
      grunt.task.run(['karma:unit'])