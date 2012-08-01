/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-rigger');

  // Project configuration.
  grunt.initConfig({
    meta: {
      version: '0.1.0',
      banner: '/*! Bronson - v<%= meta.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '* http://github.com/eclifford/R8/\n' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> ' +
        'Eric Clifford; Licensed MIT */'
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', 'lib/bronson.js', 'lib/permissions.js', 'lib/core.js', 'lib/api.js'],
        dest: 'build/bronson.js'
      }
    },
    rig: {
      amd: {
        src: ['lib/bronson.coffee'],
        dest: 'build/bronson.coffee'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'build/bronson.min.js'
      }
    },
    watch: {
      files: 'lib/*.coffee',
      tasks: 'rig'
    },
    uglify: {}
  });

  // Default task.
  grunt.registerTask('default', 'concat rig min');
};
