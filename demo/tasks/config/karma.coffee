#
# grunt-contrib-requirejs
# https://github.com/gruntjs/grunt-contrib-requirejs
#
module.exports = (grunt) ->
  options:
    files: [
      '<%= grunt.settings.paths.tempDir %>/common.js'
      '<%= grunt.settings.paths.tempDir %>/common/test/runner.js'
      {pattern: '<%= grunt.settings.paths.tempDir %>/**/*.{js,tmpl,json,html}', included: false}
    ]
    exclude: [
      '<%= grunt.settings.paths.tempDir %>/test/**/*'
    ]

    frameworks: [
      'requirejs'
      'mocha'
      'chai-jquery'
      'sinon-chai'
    ]

    reporters: [
      'progress'
      'coverage'
    ]

    preprocessors:
      '<%= grunt.settings.paths.tempDir %>/scripts/**/*.js': ['coverage']

    coverageReporter:
      type: 'html'
      dir: '<%= grunt.settings.paths.tempDir %>/test/coverage/'

    port: 9999

  unit:
    autoWatch: true
    browsers: grunt.settings.testing.browsers
    
  single:
    browsers: grunt.settings.testing.browsers