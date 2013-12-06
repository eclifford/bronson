#
# grunt-contrib-requirejs
# https://github.com/gruntjs/grunt-contrib-requirejs
#
module.exports =
  options:
    files: [
      '.tmp/common.js'
      '.tmp/common/test/runner.js'
      {pattern: '.tmp/**/*.{js,tmpl,json,html}', included: false}
    ]

    frameworks: [
      'requirejs'
      'mocha'
      'chai-jquery'
      'sinon-chai'
    ]

    reporters: [
      'progress'
      # 'coverage'
    ]

    preprocessors:
      # 'test/**/*.coffee': ['coffee']
      # 'app/scripts/**/*.coffee': ['coffee']
      '.tmp/scripts/**/*.js': ['coverage']

    coverageReporter:
      type: 'html'
      dir: 'test/output/coverage/'

    port: 9999

  unit:
    background: true
    browsers: ['PhantomJS']

  single:
    autoWatch: true
    browsers: ['PhantomJS']

