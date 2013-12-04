#
# Set RequireJS common aliases and shims
#
# @author Eric Clifford
#
require.config
  baseUrl: './'

  paths:
    # Aliases
    'bootstrap': 'vendor/bower_components/sass-bootstrap/js/'

    # Libs
    'jquery': 'vendor/bower_components/jquery/jquery'
    'underscore': 'vendor/bower_components/underscore-amd/underscore'
    'backbone': 'vendor/bower_components/backbone-amd/backbone'
    'backbone.wreqr': 'vendor/bower_components/backbone.wreqr/lib/amd/backbone.wreqr'
    'backbone.babysitter': 'vendor/bower_components/backbone.babysitter/lib/amd/backbone.babysitter'
    'marionette': 'vendor/bower_components/marionette/lib/core/amd/backbone.marionette'
    'bronson': 'vendor/bower_components/bronson/bronson'
    'text': 'vendor/bower_components/requirejs-text/text'
    'tpl': 'vendor/bower_components/requirejs-tpl/tpl'

  shim:
    'bootstrap':
      deps: ["jquery"]


