#
# Testudo Gruntfile
# @author Eric Clifford
#
module.exports = (grunt) ->
  # Load all grunt tasks
  require('load-grunt-tasks')(grunt)

  # Our configuration object
  config = grunt.settings = grunt.util._.extend
    paths:
      basePath: 'app'
      buildDir: 'dist'
      tempDir: '.tmp'
  , grunt.file.readJSON('user-settings.json')

    # Initialize Grunt
  grunt.initConfig(loadConfig('./tasks/config/', grunt))

  # Load tasks
  grunt.loadTasks('./tasks');

# Load configuration options
#
loadConfig = (path, grunt) ->
  glob = require("glob")
  object = {}
  key = undefined
  glob.sync("*",
    cwd: path
  ).forEach (option) ->
    key = option.replace(/\.coffee$/, "")
    object[key] = require(path + option)(grunt)

  object