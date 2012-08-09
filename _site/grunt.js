/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-requirejs');

  // Project configuration.
  grunt.initConfig({
    watch: {
      files: ['apps/src/**/*.coffee'],
      tasks: 'coffee'
    },
    coffee: {
      app: {
        src: ['apps/src/**/*.coffee'],
        dest: 'apps/lib',
        options: {
          bare: false,
          preserve_dirs: true,
          base_path: 'apps/src'
        }
      }
    },
    requirejs: {
      dir: 'build',
      appDir: 'apps',
      name: 'test'
    }
  });

  // Default task.
  grunt.registerTask('default', 'concat rig min');
};
