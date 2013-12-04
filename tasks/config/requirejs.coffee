#
# grunt-contrib-requirejs
# https://github.com/gruntjs/grunt-contrib-requirejs
#
module.exports =
  # Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
  dist:
    options:
      # appDir: '<%= options.tempDir %>'
      baseUrl: '<%= options.tempDir %>'
      mainConfigFile: "<%= options.tempDir %>/common.js"
      fileExclusionRegExp: new RegExp("modules/.*/[0-9A-Za-z]*Spec.js")
      dir: "<%= options.buildDir %>"
      skipDirOptimize: true
      optimizeCss: 'none'
      removeCombined: false
      preserveLicenseComments: false
      useStrict: true
      optimize: "uglify2"
      findNestedDependencies: true
      wrap: true

      # AMD Modules
      modules: [
        name: 'main'
      ,
        name: 'modules/instagram/main'
        exclude: ['main']
      ,
        name: 'modules/gmaps/main'
        exclude: ['main']
      ]
