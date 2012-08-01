module.exports['Bronson Tests'] = {
  environment: 'browser',
  rootPath: "../",

  // libraries BusterJS should include and execute
  libs: [
    'test/vendor/jquery/jquery.js',
    'test/vendor/underscore/underscore.js',
    'test/vendor/backbone/backbone.js',
    'test/vendor/requirejs/require.js',
    'test/vendor/requirejs/require.conf.js'
  ],

  // libraries BusterJS should serve, but not execute
  resources: [
    'test/vendor/requirejs/plugins/cs.js',
    'test/vendor/requirejs/plugins/coffee-script.js'
  ],

  // our source files
  sources: [
    'test/fixtures/TestModule.coffee',
    'build/bronson.coffee'
  ],

  // our tests
  tests: [
    'test/specs/*.spec.coffee'
  ],

  // the BusterJS AMD plugin
  extensions: [
    require('buster-amd')
  ],

  // Path mapper so buster-amd will use the CS plugin
  'buster-amd': {
    pathMapper: function (path) {
      return 'cs!' + path.replace(/^\//, '').replace(/\.coffee$/, '');
    }
  }
};