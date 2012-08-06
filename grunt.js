/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-rigger');
  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-buster');

  // Project configuration.
  grunt.initConfig({
    meta: {
      version: '0.1.0',
      banner: '/*! Bronson - v<%= meta.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '* http://github.com/eclifford/R8/\n' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> ' +
        'Eric Clifford; Licensed MIT */',
      csbanner: "# Bronson -v <%= meta.version %> - " +
      "<%= grunt.template.today('yyyy-mm-dd') %>\n" +
      "# http://github.com/eclifford/bronson\n" + 
      "# Copyright (c) <%= grunt.template.today('yyyy') %>" + 
      " Eric Clifford; Licensed MIT"
    },
    rig: {
      amd: {
        src: ['<banner:meta.csbanner>', 'lib/bronson.coffee'],
        dest: 'build/bronson.coffee'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', 'build/bronson.js'],
        dest: 'build/bronson.min.js'
      }
    },
    watch: {
      files: ['lib/*.coffee', 'test/**/*.spec.coffee'],
      tasks: 'rig buster coffee min'
    },
    coffee: {
      build: {
        src: ['build/bronson.coffee'],
        dest: 'build',
        options: {
          bare: false
        }
      },
      demo: {
        src: ['build/bronson.coffee'],
        dest: 'demo/javascripts/vendor/bronson',
        options: {
          bare: false
        }    
      }
    },
    buster: {
      test: {
        config: 'test/buster.js',
        reporter: 'specification'
      },
      server: {
        port: 1111
      }
    },
    uglify: {}
  });

  // Default task.
  grunt.registerTask('default', 'concat rig min');
};
