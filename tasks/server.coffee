#
# Server Task
# Task for loading a local server
#
module.exports = (grunt, target) ->
  grunt.registerTask "server", (target) ->
    return grunt.task.run(["build", "connect:dist:keepalive"]) if target is "dist"
    grunt.task.run ["clean:server", "concurrent:server", "connect:livereload", "watch"]
