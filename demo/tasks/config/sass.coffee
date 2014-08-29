module.exports = (grunt) ->
  dev:
    expand: true
    cwd: "<%= grunt.settings.paths.basePath %>"
    src: ["modules/**/*.{scss,sass}", "main.{scss,sass}"]
    dest: "<%= grunt.settings.paths.tempDir %>"
    ext: ".css"
