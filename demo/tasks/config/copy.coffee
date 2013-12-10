#
# grunt-contrib-copy
# https://github.com/gruntjs/grunt-contrib-copy
#
module.exports =
  assets:
    expand: true
    dot: true
    cwd: '<%= options.basePath %>'
    src: ['**/*.{html,jsp,js,css,woff,ttf,svg,jpeg}', '!**/vendor/**/*']
    dest: '<%= options.tempDir %>'

