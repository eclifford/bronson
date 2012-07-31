/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-rigger');

  // Project configuration.
  grunt.initConfig({
    meta: {
      version: '0.1.0',
      banner: '/*! R8 - v<%= meta.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '* http://github.com/eclifford/R8/\n' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> ' +
        'Eric Clifford; Licensed MIT */'
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', 'lib/r8.js', 'lib/permissions.js', 'lib/core.js', 'lib/api.js'],
        dest: 'build/r8.js'
      }
    },
    rig: {
      amd: {
        src: ['r8/r8.coffee'],
        dest: 'build/r8.coffee'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'build/r8.min.js'
      }
    },
    watch: {
      files: 'r8/*.coffee',
      tasks: 'rig'
    },
    uglify: {}
  });

  // Default task.
  grunt.registerTask('default', 'concat rig min');
};
