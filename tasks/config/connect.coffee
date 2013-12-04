#
# grunt-contrib-connect
# https://github.com/gruntjs/grunt-contrib-connect
#
module.exports =
  options:
    port: 9000
    livereload: 35729
    # change this to '0.0.0.0' to access the server from outside
    hostname: 'localhost'

  livereload:
    options:
      open: true
      base: [
        '<%= options.basePath %>'
        '<%= options.tempDir %>'
      ]

  dist:
    options:
      open: true
      base: '<%= options.buildDir %>'
