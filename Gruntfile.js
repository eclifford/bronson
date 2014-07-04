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
      }
    },
    bump: {
      options: {
        files: ['package.json', 'bower.json'],
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
