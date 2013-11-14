module.exports = function(grunt) {
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
          '<%= pkg.author %> - <%= grunt.template.today("yyyy-mm-dd") %> */'
      },
      dist: {
        files: {
          'bronson.min.js': ['bronson.js']
        }
      }
    },
    jshint: {
      options: {
        loopfunc: true
      },
      all: ['Gruntfile.js', 'bronson.js']
    },
    watch: {
       files: ['Gruntfile.js', 'bronson.js'],
       tasks: ['jshint', 'karma:unit:run']
    },
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
        background: true,
        browsers: ['Chrome']
      }
    },
    release: {
      options: {
        file: 'bower.json',
        npm: false,
        github: {
          repo: 'eclifford/bronson',
          usernameVar: 'GITHUB_USERNAME',
          passwordVar: 'GITHUB_PASSWORD'
        }
      }
    }
  });

  grunt.registerTask('default', ['karma:unit:start', 'watch']);
  grunt.registerTask('build', ['jshint', 'uglify']);
};