module.exports = 
  dev:
    expand: true
    cwd: "<%= options.basePath %>"
    src: ["**/*.{scss,sass}", "!**/vendor/**/*.{scss,sass}"]
    dest: "<%= options.tempDir %>"
    ext: ".css"