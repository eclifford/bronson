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
        browsers: ['PhantomJS']
      }
    },
    bump: {
      options: {
        files: ['package.json', 'bower.json'],
        commit: false,
        createTag: false,
        push: false
      }
    },  
    release: {
      options: {
        file: 'bower.json',
        npm: false,
        bump: false,
        github: {
          repo: 'eclifford/bronson',
          usernameVar: 'GITHUB_USERNAME',
          passwordVar: 'GITHUB_PASSWORD'
        }
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
  grunt.registerTask('deploy', ['bump', 'replace', 'build', 'release']);
};