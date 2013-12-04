#
# grunt-contrib-clean
# https://github.com/gruntjs/grunt-contrib-clean
#
module.exports =
  options:
    force: true # watch yourself there be dragons

  dist: [
    "<%= options.tempDir %>",
    "<%= options.buildDir %>"
  ]
  server: [
    "<%= options.tempDir %>"
  ]
