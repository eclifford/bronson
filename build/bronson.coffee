# Bronson -v 0.1.0 - 2012-08-14
# http://github.com/eclifford/bronson
# Copyright (c) 2012 Eric Clifford; Licensed MIT
((root, factory) ->
  if typeof define is "function" and define.amd
    # AMD. Register as an anonymous module.
    define [], factory()
  else   
    # Browser globals
    root.Bronson = factory()
) this, () ->

  Bronson = window.Bronson =
    version: "0.1.0"

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
  
    # stopAllModules
    # Stop all instanced modules
    #
    stopAllModules: () ->
      Bronson.Core.stopAllModules()
  
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
  
  
  
  # Bronson Permissions 
  # Permissions layer for Bronson
  #
  # @author Eric Clifford
  # @version 0.1.0
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
  # @version 0.1.0
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
      if not event? || typeof event isnt "string"
        throw new Error "Bronson.Core#publish: must supply a valid event"
  
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
    # @param callback [Function] the method to invoke 
    #
    # @example
    #   Bronson.Core.subscribe 'TestModule', 'TestEvent', ->
    #     console.log 'Event has been triggered'
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
    unsubscribe: (subscriber, event) ->
      for item, i in @events[event]
        if item.subscriber == subscriber
          @events[event].splice i, 1
  
    # Unsubscribe subscriber from all events
    # @param subscriber [String] The module to unsubscribe
    #
    # @example
    #   Bronson.Core.unsubscribeAll 'TestModule'
    #
    unsubscribeAll: (subscriber) ->
      for event of @events
        if @events.hasOwnProperty(event) 
          # Iterate through events and remove subscribers
          for subscriber, y in @events[event]
            if subscriber == subscriber
              @events[event].splice y, 1
          # If event is empty delete it
          if @events[event].length == 0
            delete @events[event]  
     
    # Load a module
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
    #   Bronson.Core.loadModule 'TestModule', {foo: 'bar'}, ->
    #     console.log 'module has been created'
    #
    loadModule: (module, config, callback, autostart) -> 
      # Verify the input paramaters
      if not module? || typeof module isnt 'string'
        throw new Error "Bronson.Core#loadModule: must supply a valid module"
  
      if autostart? and typeof autostart isnt 'boolean'
        throw new Error "Bronson.Core#loadModule: autostart must be a valid boolean"
  
      # Load the module through RequireJS
      require ['module', module], (Module, LoadedModule) =>
        try 
          _module = new LoadedModule(config)
          _module.id = Module.id
  
          # Create the module if it doesn't exist otherwise select it
          @modules[module] = (if (not @modules[module]) then [] else @modules[module])
  
          # Store the loaded module
          @modules[module].push
            id: _module.id 
            timeStamp: new Date()
            started: _module.started
            disposed: _module.disposed
            load: _module.load
            start: _module.start
            stop: _module.stop
            unload: _module.unload
  
          # Load the module
          _module.load()
  
          # Start the module if specified
          _module.start() if autostart
  
          # Return a reference to the module we added
          callback(@modules[module][@modules[module].length - 1])
        catch e 
          throw new Error "Bronson.Core#loadModule: #{e}"
  
    # Stop all modues
    #
    # @example
    #   Bronson.Core.stopAllModules()
    #
    unloadAllModules: () ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance in @modules[module]
            @unloadModule instance.id
  
    # Stop module
    #
    # @example
    #   Bronson.Core.stopModule 'TestModule'
    #
    unloadModule: (id) ->
      # Validate input parameters
      if not id? || typeof id isnt "string"
        throw new Error "Bronson.Core#stopModule: id must be valid"
  
      try 
        for module of @modules
          if @modules.hasOwnProperty(module) 
            for instance, y in @modules[module]
              if instance.id == id
                instance.unload()
                delete @modules[module][y] 
  
        if @modules[module].length == 0
          require.undef module
  
      catch e
        throw new Error "Bronson.Core#stopModule: #{e}"
  
    # startModule
    # A module by default may not be started and may need done so manually
    #
    # @param @id [string] The RequireJS id of the loaded module instance
    #
    # @example
    #   Bronson.Core.startModule 'TestModule'
    #
    startModule: (id) ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance, y in @modules[module]
            if instance.id == id
              instance.start()
  
    # stopModule
    # A module may be stopped manually
    # 
    # param @id [string] The RequireJS id of the loaded module instance
    #
    stopModule: (id) ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance in @modules[module]
            if instance.id == id
              instance.stop()
  
    # stopAllModules
    # Stop all instanced modules
    #
    stopAllModules: () ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance in @modules[module]
            @stopModule instance.id
  
  
  
  
  
  
  # Bronson Module
  #
  # @author Eric Clifford
  # @version 0.1.0
  #
  class Bronson.Module
    id: "" 
    disposed: false 
    started: false
  
    # Constructor
    #
    constructor: ->
  
    # Initialize
    #
    load: ->
      throw new Error "Bronson.Module#initialize: must override initialize"
  
    # Start
    #
    start: ->
      @started = true
  
    # Stop
    #
    stop: ->
      @started = false
  
    # Cleanup this controller
    # 
    # @example
    #   @unload()
    #
    unload: ->
      return if @disposed
  
      # Finished
      @disposed = true
  
      # Make this object immutable
      Object.freeze? this
  # Bronson Util 
  # Permissions layer for Bronson
  #
  # @author Eric Clifford
  # @version 0.1.0
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