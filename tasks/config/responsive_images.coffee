module.exports = 
  dev:
    options:
      sizes: [
        width: 320
      ,
        width: 640
      , 
        width: 1024
      ]
    files: [
      expand: true
      cwd: 'app/images'
      src: ['*.{jpg,gif,png}']
      dest: '.tmp/images'
    ]