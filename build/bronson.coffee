# Bronson -v 0.1.0 - 2012-08-07
# http://github.com/eclifford/bronson
# Copyright (c) 2012 Eric Clifford; Licensed MIT
((root, factory) ->
  if typeof define is "function" and define.amd
    # AMD. Register as an anonymous module.
    define [], factory
  else   
    # Browser globals
    root.Bronson = factory(root.b)
) this, () ->

  Bronson = window.Bronson =
    version: "0.0.1"

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
  
  
  
  # Bronson Permissions 
  # Permissions layer for Bronson
  #
  # @author Eric Clifford
  # @version 0.0.1
  #
  Permissions = Bronson.Permissions =
    # Whether or not the permissions are activated
    enabled: false
  
    # Application rules
    rules: {}
  
    # Overwrite the application rules
    set: (props) ->
      @rules = Bronson.Util.extend(@rules, props)
  
    # Validate a subscribers permission for subscribing to a channel
    #
    # @param subscriber [string] the subscriber 
    # @param channel [string] the channel
    #
    validate: (subscriber, channel) ->
      # Validate inputs
      if not subscriber? || typeof subscriber isnt 'string'
        throw new Error 'Bronson.Permissions#validate: must provide a valid subscriber'
      if not channel? || typeof channel isnt 'string'
        throw new Error 'Bronson.Permissions#validate: must provide a valid channel' 
       
      if @enabled 
        test = @rules[subscriber]?[channel]
        return if test is undefined then false else test
      else 
        return true
  # Bronson Core
  #
  # @author Eric Clifford
  # @version 0.0.1
  #
  Core = Bronson.Core = 
    events: {}
    modules: {}
  
    # Publish an event to it's subscribers
    # @param event [String] the event to publish to
    #
    # @example
    #   Bronson.Core.publish 'TestEvent'
    #
    publish: (event) ->
      # Verify our input parameters
      if not event?
        throw new Error "Bronson.Core#publish: event must be defined"
  
      if typeof event isnt "string"
        throw new Error "Bronson.Core#publish: event must be a string" 
  
      # Verify that the event exists
      if !@events[event]
        return true
  
      # Get all subscribers to this event
      subscribers = @events[event].slice()
  
      # Get the arguments
      args = [].slice.call(arguments, 1)
  
      # Call the callback method on all subscribers
      for subscriber in subscribers
        subscriber.callback.apply this, args
  
    # Subscribe a module to an event
    #
    # @param subscriber [String] The module to subscribe
    # @param event [String] The event to listen on
    # @param callback [Function] the callback
    #
    # @example
    #   Bronson.Core.subscribe 'TestModule', 'TestEvent', ->
    #     console.log 'Module succesfully subscribed'
    #
    subscribe: (subscriber, event, callback) -> 
      # Verify our input parameters
      if not subscriber? || typeof subscriber isnt "string"
        throw new Error "Bronson.Core#subscribe: must supply a valid subscriber"
     
      if not event? || typeof event isnt "string"
        throw new Error "Bronson.Core#subscribe: must supply a valid event"
  
      if callback? and typeof callback isnt "function"
        throw new Error "Bronson.Core#subscribe: callback must be a function"   
  
      # Create the event if it doesn't exist otherwise select it
      @events[event] = (if (not @events[event]) then [] else @events[event])
  
      # Push the event
      @events[event].push 
        subscriber: subscriber
        callback: callback
  
    # Unsubscribe a subscriber from a event
    # @param subscriber [String] The module to subscribe
    # @param event [String] The event to listen on
    # 
    # @example
    #   Bronson.Core.unsubscribe 'TestModule', 'TestEvent', ->
    #     console.log 'Module succesfully unsubscribed'
    #
    unsubscribe: (subscriber, event, callback) ->
      for item, i in @events[event]
        if item.subscriber == subscriber
          @events[event].splice i, 1
      callback()
  
    # Unsubscribe subscriber from all events
    # @param subscriber [String] The module to unsubscribe
    #
    # @example
    #   Bronson.Core.unsubscribeAll 'TestModule'
    #
    unsubscribeAll: (subscriber, callback) ->
      for event of @events
        if @events.hasOwnProperty(event) 
          # Iterate through events and remove subscribers
          for subscriber, y in @events[event]
            if subscriber == subscriber
              @events[event].splice y, 1
          # If event is empty delete it
          if @events[event].length == 0
            delete @events[event]
      callback()      
     
    # Create a module
    #
    # @param moduleId [String] the AMD module to load(alias or relative path)
    # @param autostart [Boolean] whether or not to autostart the module
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
    #   Bronson.Core.createModule 'TestModule', {foo: 'bar'}, ->
    #     console.log 'module has been created'
    #
    loadModule: (module, obj..., callback, autostart) ->  
      # Verify the input paramaters
      if not module?
        throw new Error "Bronson.Core#createModule: module must be defined"
  
      if typeof module isnt 'string'
        throw new Error "Bronson.Core#createModule: module must be a string"
  
      if autostart? and typeof autostart isnt 'boolean'
        throw new Error "Bronson.Core#createModule: autostart must be a valid boolean"
  
      obj = obj[0]
  
      # Load the module through RequireJS
      require ['module', module], (Module, LoadedModule) =>
        try 
          _module = new LoadedModule(obj)
          _module.id = Module.id
  
          # Create the module if it doesn't exist otherwise select it
          @modules[module] = (if (not @modules[module]) then [] else @modules[module])
  
          # Store the loaded module
          @modules[module].push
            id: _module.id 
            timeStamp: new Date()
            start: _module.start
            stop: _module.stop
  
          # State the module if specified
          _module.start() if autostart
  
          callback(_module)
        catch e 
          throw new Error "Bronson.Core#createModule: #{e}"
  
    # Stop all modues
    #
    # @example
    #   Bronson.Core.stopAllModules()
    #
    unloadAllModules: (callback) ->
      for id of modules
        @unloadModule id
      callback()
  
    # Stop module
    #
    # @example
    #   Bronson.Core.stopModule 'TestModule'
    #
    unloadModule: (module, callback)->
      # Validate input parameters
      if not module? || typeof module isnt "string"
        throw new Error "Bronson.Core#stopModule: module must be valid"
  
      if not @modules[module]?
        throw new Error "Bronson.Core#stopModule: that module is not loaded"
  
      try 
        require.undef(module) 
        @unsubscribeAll module, -> 
  
      catch e
        throw new Error "Bronson.Core#stopModule: #{e}"
     
      callback()
  
    startModule: (id) ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance, y in @modules[module]
            if instance.id == id
              instance.start()
  
    stopModule: (id) ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance, y in @modules[module]
            if instance.id == id
              instance.stop()
  
  
  
  
  
  # Bronson Module
  #
  # @author Eric Clifford
  # @version 0.0.1
  #
  class Bronson.Module
    id: ""
    disposed: false 
  
    # Constructor
    #
    constructor: ->
      @initialize arguments...
  
    # Initialize
    #
    initialize: ->
      throw new Error "Bronson.Module#initialize: must override initialize"
  
    # Start
    #
    start: ->
      throw new Error "Bronson.Module#start: must override start"
  
    # Stop
    #
    stop: ->
      throw new Error "Bronson.Module#stop: must override stop"
  
    # Cleanup this controller
    # 
    # @example
    #   @dipose()
    #
    dispose: ->
      return if @disposed
  
      # Dispose and delete all members which are disposable
      for own prop of this
        obj = this[prop]
        if obj and typeof obj.dispose is 'function'
          obj.dispose()
          delete this[prop]
  
      # Stop this module and remove all events
      #Bronson.Core.stopModule @id, ->
  
      # Finished
      @disposed = true
  
      # Make this object immutable
      Object.freeze? this
  # Bronson Util 
  # Permissions layer for Bronson
  #
  # @author Eric Clifford
  # @version 0.0.1
  #
  Util = Bronson.Util =
    extend: (object, extenders...) ->
      return {} if not object?
      for other in extenders
        for own key, val of other
          if not object[key]? or typeof val isnt "object"
            object[key] = val
          else
            object[key] = @extend object[key], val
  
      object
  
  

  # Just return a value to define the module export.
  # This example returns an object, but the module
  # can return a function as the exported value.
  return Bronson