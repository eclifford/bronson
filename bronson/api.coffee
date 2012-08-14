# Bronson Api
# Interface layer for Bronson
#
# @author Eric Clifford
# @version 0.1.0
#
Api = Bronson.Api = 
  # Publish an event to a event
  # @param event [String] the event to publish to
  #
  # @example
  #   Bronson.Api.publish 'TestEvent'
  #
  publish: (event) ->
    # Pass to the core
    Bronson.Core.publish event, arguments[1]

  # Subscribe a module to an event while validating a modules
  # permission to subscribe to said event
  #
  # @param subscriber [String] The module to subscribe
  # @param event [String] The event to listen on
  # @param callback [Function] the callback
  #
  # @example 
  #   Bronson.Api.subscribe 'TestModule', 'TestEvent', ->
  #     console.log 'subscription successful'
  #
  subscribe: (subscriber, event, callback) ->   
    # Validate permissions of this module to subscribe
    if Permissions.validate subscriber, event 
      Bronson.Core.subscribe subscriber, event, callback
    else 
      throw new Error "Bronson.Api#subscribe: Subscriber #{subscriber} not allowed to listen on event #{event}"

  # Unsubscribe a subscriber from a event
  # @param subscriber [String] The module to subscribe
  # @param event [String] The event to listen on
  # 
  # @example 
  #   Bronson.Api.unsubscribe 'TestModule', 'TestEvent', ->
  #     console.log 'unsubscribe successful'
  #
  unsubscribe: (subscriber, event) ->    
    # Pass to the core
    Bronson.Core.unsubscribe subscriber, event
 
  # Load a module
  #
  # @param module [String] the AMD module to load
  # @param callback [Function] the callback
  # @param config [Object] the configuration object
  # @param autostart [Boolean] whether or not to start the module
  #
  # @todo
  #   - change splat optional parameter to more terse optional argument as outlined
  #     here https://github.com/jashkenas/coffee-script/issues/1091
  #   - We need to renable to check to verify that a module has a dispose/init method for efficent
  #     garbage collection
  #
  # @example
  #   Bronson.Api.loadModule 'TestModule', ->
  #     console.log 'module has been loaded'
  #   , {foo: 'bar'}
  #   , true
  #
  loadModule: (module, callback, config={}, autostart=true) ->  
    # Pass to core
    Bronson.Core.loadModule module, config, callback, autostart

  # Stop all modues
  #
  # @example
  #   Bronson.Api.unloadAllModules()
  #
  unloadAllModules: ->
    Bronson.Core.unloadAllModules()

  # Stop module
  #
  # @example
  #   Bronson.Api.unloadModule 'TestModule'
  #
  unloadModule: (moduleId)->
    # Pass to core
    Bronson.Core.unloadModule moduleId, callback

  # Start the module
  #
  # @example
  #   Bronson.Api.startModule 'r11'
  #
  startModule: (id) ->
    Bronson.Core.startModule moduleId

  # Stop the module
  #
  # @example 
  #   Bronson.Api.stopModule 'r11'
  #
  stopModule: (id) ->
    Bronson.Core.stopModule moduleId

  # Set the application permissions
  #
  # @param permissions [Object] the object containing permissions
  #
  #
  setPermissions: (permissions) ->
    Bronson.Permissions.set permissions

  # Get the module info
  #
  # @example
  #   Bronson.Api.getModulesInfo
  #
  getModulesInfo: ->
    return Bronson.Core.modules

  # Get the events info
  #
  # @example
  #   Bronson.Api.getEventsInfo
  #
  getEventsInfo: ->
    return Bronson.Core.events


