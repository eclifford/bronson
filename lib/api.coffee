# Bronson Api
# Interface layer for Bronson
#
# @author Eric Clifford
# @version 0.0.1
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
  unsubscribe: (subscriber, event, callback) ->    
    # Pass to the core
    Bronson.Core.unsubscribe subscriber, event, callback
 
  # Load a module
  #
  # @param module [String] the AMD module to load
  # @param obj... [Object] the optional configuration object
  # @param callback [Function] the callback
  #
  # @todo
  #   - change splat optional parameter to more terse optional argument as outlined
  #     here https://github.com/jashkenas/coffee-script/issues/1091
  #   - We need to renable to check to verify that a module has a dispose/init method for efficent
  #     garbage collection
  #
  # @example
  #   Bronson.Api.createModule 'TestModule', {foo: 'bar'}, ->
  #     console.log 'module has been created'
  #
  loadModule: (moduleId, obj..., callback, autostart=true) ->  
    # Pass to core
    Bronson.Core.loadModule moduleId, autostart, obj..., callback

  # Stop all modues
  #
  # @example
  #   Bronson.Api.stopAllModules()
  #
  unloadAllModules: ->
    Bronson.Core.unloadAllModules()

  # Stop module
  #
  # @example
  #   Bronson.Api.stopModule 'TestModule'
  #
  unloadModule: (moduleId, callback)->
    # Pass to core
    Bronson.Core.unloadModule moduleId, callback

  startModule: (id) ->
    Bronson.Core.startModule moduleId

  stopModule: (id) ->
    Bronson.Core.stopModule moduleId

  # Set the application permissions
  #
  # @param permissions [Object] the object containing permissions
  #
  #
  setPermissions: (permissions) ->
    Bronson.Permissions.set permissions

  getModulesInfo: ->
    return Bronson.Core.modules

  getEventsInfo: ->
    return Bronson.Core.events


