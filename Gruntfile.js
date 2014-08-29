module.exports = function(grunt) {
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('bower.json'),
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
          '<%= pkg.authors[0] %> - <%= grunt.template.today("yyyy-mm-dd") %> */'
      },
      dist: {
        files: {
          'bronson.min.js': ['bronson.js']
        }
      }
    },
    jshint: {
      options: {
        loopfunc: true,
        '-W058': true
      },
      all: ['Gruntfile.js', 'bronson.js']
    },
    watch: {
      files: ['Gruntfile.js', 'bronson.js', 'test/**/*.js'],
      tasks: ['jshint', 'karma:unit:run']
    },
    copy: {
      bronson: {
        src: 'bronson.js',
        dest: 'demo/app/vendor/bronson.js'
      }
    },
    karma: {
      options: {
        basePath: '',

        frameworks: ['requirejs' ,'mocha', 'chai-jquery', 'jquery-1.8.3', 'sinon-chai'],

        reporters: ['progress'],

        files: [
          {pattern: 'bronson.js', included: false},
          {pattern: 'bower_components/async/lib/async.js', included: false},
          {pattern: 'test/fixtures/**/*.js', included: false},
          {pattern: 'test/unit/specs/*.js', included: false},
          'test/unit/runner.js'
        ],

        autoWatch: false

      },
      unit: {
        background: true,
        browsers: ['PhantomJS']
      },
      single: {
        background: false,
        singleRun: true,
        browsers: ['PhantomJS']
      },
      ci: {
        sauceLabs: {
          testName: 'Bronson Unit Tests'
        },
        singleRun: true,
        customLaunchers: {
          sl_chrome: {
            base: 'SauceLabs',
            browserName: 'chrome',
            platform: 'Windows 7',
            version: '35'
          },
          sl_firefox: {
            base: 'SauceLabs',
            browserName: 'firefox',
            version: '30'
          },
          sl_ios_safari: {
            base: 'SauceLabs',
            browserName: 'iphone',
            platform: 'OS X 10.9',
            version: '7.1'
          },
          sl_ie_11: {
            base: 'SauceLabs',
            browserName: 'internet explorer',
            platform: 'Windows 8.1',
            version: '11'
          }
        },
        browsers: ['sl_chrome', 'sl_firefox', 'sl_ie_11'],
        reporters: ['dots', 'saucelabs']
      }
    },
    bump: {
      options: {
        files: ['package.json', 'bower.json'],
        updateConfigs: ['pkg'],
        commit: false,
        createTag: false,
        push: false,
        commitFiles: ['-a']
      }
    },
    replace: {
      dist: {
        src: ['bronson.js'],
        overwrite: true,
        replacements: [{
          from: /version:.'[0-9]+.[0-9]+.[0-9]+'/g,
          to: "version: '<%= pkg.version %>'"
        }]
      }
    }
  });

  grunt.registerTask('default', ['karma:unit:start', 'watch']);
  grunt.registerTask('build', ['jshint', 'uglify']);
  grunt.registerTask('release', ['bump', 'replace', 'build']);
};
