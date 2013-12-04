#
# grunt-contrib-coffee
# https://github.com/gruntjs/grunt-contrib-coffee
#
module.exports =
  dev:
    expand: true
    cwd: "<%= options.basePath %>"
    src: ["**/*.coffee", "!**/vendor/**/*.coffee"]
    dest: "<%= options.tempDir %>"
    ext: ".js"
