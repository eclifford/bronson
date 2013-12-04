#
# Visa Gruntfile
# @author Eric Clifford
#
module.exports = (grunt) ->
  # Load all grunt tasks
  require('load-grunt-tasks')(grunt)

  # Our configuration object
  config = 
    options: 
      basePath: 'app'
      buildDir: 'dist'
      tempDir: '.tmp'

  # Load options
  grunt.util._.merge(config, loadConfig('./tasks/config/'))

  # Initialize Grunt
  grunt.initConfig(config)

  # Load tasks
  grunt.loadTasks('./tasks');

# Load configuration options
#
loadConfig = (path) ->
  glob = require("glob")
  object = {}
  key = undefined
  glob.sync("*",
    cwd: path
  ).forEach (option) ->
    key = option.replace(/\.coffee$/, "")
    object[key] = require(path + option)

  object
