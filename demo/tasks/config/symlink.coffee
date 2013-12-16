#
# grunt-contrib-symlink
# https://github.com/gruntjs/grunt-contrib-symlink
#
module.exports =
  options:
    overwrite: true

  expanded:
    files: [
      expand: true
      cwd: 'app/vendor'
      src: ['*']
      dest: '.tmp/vendor'
    ]
