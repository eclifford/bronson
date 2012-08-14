/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-rigger');
  grunt.loadNpmTasks('grunt-buster');
  grunt.loadNpmTasks('grunt-contrib');

  // Project configuration.
  grunt.initConfig({
    meta: {
      version: '0.1.0',
      banner: '/*! Bronson - v<%= meta.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '* http://github.com/eclifford/bronson/\n' +
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
        src: ['<banner:meta.csbanner>', 'bronson/bronson.coffee'],
        dest: 'build/bronson-<%= meta.version %>.coffee'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', 'build/bronson-<%= meta.version %>.js'],
        dest: 'build/bronson-<%= meta.version %>.min.js'
      }
    },
    watch: {
      files: ['bronson/*.coffee', 'test/**/*.spec.coffee'],
      tasks: 'rig copy coffee min buster'
    },
    coffee: {
      compile: {
        options: {
          bare: true
        },
        files: {
          "build/bronson-<%= meta.version %>.js": "build/bronson-<%= meta.version %>.coffee"
        }
      }
    },
    copy: {
      dist: {
        files: {
          "build/": ["build/bronson-<%= meta.version %>.coffee"]
        },
        options: {
          processName: function(fileName) {
            return 'bronson.coffee'
          }
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
    server: {
      port: 8000,
      base: '.'
    },
    uglify: {}
  });

  // Default task.
  grunt.registerTask('default', 'concat rig min');
};
