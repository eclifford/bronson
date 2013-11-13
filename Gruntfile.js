module.exports = function(grunt) {
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    karma: {
      options: {
        basePath: '',

        frameworks: ['requirejs' ,'mocha', 'chai-jquery', 'sinon-chai'],

        reporters: ['progress'],

        files: [
          {pattern: 'bronson.js', included: false},
          {pattern: 'test/fixtures/**/*.js', included: false},
          {pattern: 'test/unit/specs/*.js', included: false},
          'test/unit/runner.js'
        ],

        autoWatch: true
      },
      unit: {
        // background: true,
        // configFile: 'karma.conf.js',
        browsers: ['Chrome']
      }
    }
  });

  grunt.registerTask('default', ['karma']);
};