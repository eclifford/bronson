#
# Capture events emitting from watch task and target them so that
# we can compile one file at a time
#
path = require('path')

module.exports = (grunt) ->
  grunt.event.on "watch", (action, filepath, target) ->
    switch target
      # Compile only the files that have changed
      when "assets"
        grunt.config ["copy", "assets", "src"], filepath.replace(grunt.config.get('copy.assets.cwd') + '/', '')
      when "coffee"
        grunt.config ["coffee", "dev", "src"], filepath.replace(grunt.config.get('coffee.dev.cwd') + '/', '')
