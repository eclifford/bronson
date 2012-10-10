((root, factory) ->
  if typeof define is "function" and define.amd
    # AMD. Register as an anonymous module.
    define [], factory()
  else   
    # Browser globals
    root.Bronson = factory()
) this, () ->

  Bronson = window.Bronson =
    version: "0.1.1"

  # Utility function watching for RequireJS errors
  # @ param err [String] the error 
  #
  require.onError = (err) ->
    if err.requireType is 'timeout'
      console.error "Could not load module #{err.requireModules}"
    else
      failedId = err.requireModules && err.requireModules[0]
      require.undef failedId
      throw err

  requirejs.onResourceLoad = (context, map, depArray) ->

  #= api
  #= permissions
  #= core
  #= module
  #= util

  # A few aliases
  Bronson['publish'] = Bronson.Api.publish
  Bronson['subscribe'] = Bronson.Api.subscribe
  Bronson['unsubscribe'] = Bronson.Api.unsubscribe

  # Just return a value to define the module export.
  # This example returns an object, but the module
  # can return a function as the exported value.
  return Bronson