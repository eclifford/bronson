# Bronson -v 0.1.0 - 2012-08-06
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
    # Publish an event to a channel
    # @param channel [String] the channel to publish to
    #
    # @example
    #   Bronson.Api.publish 'TestEvent'
    #
    publish: (channel) ->
      if not channel? || typeof channel isnt "string"
        throw new Error "Bronson.Api#publish: a valid channel must be supplied"
  
      # Pass to the core
      Bronson.Core.publish channel, arguments[1]
      
    # Subscribe a module to an event while validating a modules
    # permission to subscribe to said event
    #
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # @param callback [Function] the callback
    #
    # @example 
    #   Bronson.Api.subscribe 'TestModule', 'TestEvent', ->
    #     console.log 'subscription successful'
    #
    subscribe: (subscriber, channel, callback) -> 
      # Validate inputs
      if not subscriber? || typeof subscriber isnt "string"
        throw new Error "Bronson.Api#subscribe: a valid subscriber must be supplied"
      if not channel? || typeof channel isnt "string" 
        throw new Error "Bronson.Api#subscribe: a valid channel must be supplied"
      if callback? && typeof callback isnt "function"
        throw new Error "Bronson.Api#subscribe: callback must be a function"
  
      # Validate permissions of this module to subscribe
      if Permissions.validate subscriber, channel
        Bronson.Core.subscribe subscriber, channel, callback
      else 
        throw new Error "Bronson.Api#subscribe: Subscriber #{subscriber} not allowed to listen on channel #{channel}"
  
    # Unsubscribe a subscriber from a channel
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # 
    # @example 
    #   Bronson.Api.unsubscribe 'TestModule', 'TestEvent', ->
    #     console.log 'unsubscribe successful'
    #
    unsubscribe: (subscriber, channel) ->
      # Validate inputs
      if not subscriber? || typeof subscriber isnt "string"
        throw new Error "Bronson.Api#unsubscribe: a valid subscriber must be supplied"
      if not channel? || typeof channel isnt "string"
        throw new Error "Bronson.Api#unsubscribe: a valid channel must be supplied"
  
      # Pass to the core
      Bronson.Core.unsubscribe subscriber, channel
   
    # Create a module
    #
    # @param moduleId [String] the AMD module to load
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
    createModule: (moduleId, obj..., callback) ->  
      # Validate inputs
      if not moduleId || typeof moduleId isnt "string"
        throw new Error "Bronson.Api#createModule: a valid module alias or path must be supplied"
      if callback? and typeof callback isnt "function" 
        throw new Error "Bronson.Api#createModule: callback must be a function"
  
      # Pass to core
      Bronson.Core.createModule moduleId, obj..., callback
  
    # Stop all modues
    #
    # @example
    #   Bronson.Api.stopAllModules()
    #
    stopAllModules: ->
      Bronson.Core.stopAllModules()
  
    # Stop module
    #
    # @example
    #   Bronson.Api.stopModule 'TestModule'
    #
    stopModule: (moduleId, callback)->
      # Validate inputs
      if not moduleId || typeof moduleId isnt "string"
        throw new Error "Bronson.Api#stopModule: a valid module alias or path must be supplied"
      if callback? and typeof callback isnt "function"
        throw new Error "Bronson.Api#stopModule: callback must be a function"
  
      # Pass to core
      Bronson.Core.stopModule moduleId, callback
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
    extend: (props) ->
      rules = Bronson.Util.extend(rules, props)
  
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
    channels: {}
    modules: {}
  
    # Publish an event to a channel
    # @param channel [String] the channel to publish to
    #
    # @example
    #   Bronson.Core.publish 'TestEvent'
    #
    publish: (channel) ->
      # Verify our input parameters
      if not channel?
        throw new Error "Bronson.Core#publish: channel must be defined"
  
      if typeof channel isnt "string"
        throw new Error "Bronson.Core#publish: channel must be a string" 
  
      # Verify that the channel exists
      if !@channels[channel]
        return true
  
      # Get all subscribers to this channel
      subscribers = @channels[channel].slice()
  
      # Get the arguments
      args = [].slice.call(arguments, 1)
  
      # Call the callback method on all subscribers
      for subscriber in subscribers
        subscriber.callback.apply this, args
  
    # Subscribe a module to an event
    #
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # @param callback [Function] the callback
    #
    # @example
    #   Bronson.Core.subscribe 'TestModule', 'TestEvent', ->
    #     console.log 'Module succesfully subscribed'
    #
    subscribe: (subscriber, channel, callback) -> 
      # Verify our input parameters
      if not subscriber? || typeof subscriber isnt "string"
        throw new Error "Bronson.Core#subscribe: must supply a valid subscriber"
     
      if not channel? || typeof channel isnt "string"
        throw new Error "Bronson.Core#subscribe: must supply a valid channel"
  
      if callback? and typeof callback isnt "function"
        throw new Error "Bronson.Core#subscribe: callback must be a function"   
  
      # Create the channel if it doesn't exist otherwise select it
      @channels[channel] = (if (not @channels[channel]) then [] else @channels[channel])
  
      # Push the event
      @channels[channel].push 
        subscriber: subscriber
        callback: callback
  
    # Unsubscribe a subscriber from a channel
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # 
    # @example
    #   Bronson.Core.unsubscribe 'TestModule', 'TestEvent', ->
    #     console.log 'Module succesfully unsubscribed'
    #
    unsubscribe: (subscriber, channel) ->
      for item, i in @channels[channel]
        if item.subscriber == subscriber
          @channels[channel].splice i, 1
  
    # Unsubscribe subscriber from all channels
    # @param subscriber [String] The module to unsubscribe
    #
    # @example
    #   Bronson.Core.unsubscribeAll 'TestModule'
    #
    unsubscribeAll: (subscriber) ->
      for channel of @channels
        if @channels.hasOwnProperty(channel) 
          # Iterate through channels and remove subscribers
          for subscriber, y in @channels[channel]
            if subscriber == subscriber
              @channels[channel].splice y, 1
          # If channel is empty delete it
          if @channels[channel].length == 0
            delete @channels[channel]
     
    # Create a module
    #
    # @param moduleId [String] the AMD module to load(alias or relative path)
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
    createModule: (moduleId, obj..., callback) ->  
      # Verify the input paramaters
      if not moduleId?
        throw new Error "Bronson.Core#createModule: moduleId must be defined"
  
      if typeof moduleId isnt 'string'
        throw new Error "Bronson.Core#createModule: moduleId must be a string"
  
      obj = obj[0]
  
      # Load the module through RequireJS
      require [moduleId], (module) =>
        try 
          _module = new module(obj)
          _module.id = moduleId
          @modules[moduleId] = _module      
          callback(_module)
        catch e 
          throw new Error "Bronson.Core#createModule: #{e}"
  
    # Stop all modues
    #
    # @example
    #   Bronson.Core.stopAllModules()
    #
    stopAllModules: ->
      for id of modules
        @stopModule id
  
    # Stop module
    #
    # @example
    #   Bronson.Core.stopModule 'TestModule'
    #
    stopModule: (moduleId, callback)->
      # Validate input parameters
      if not moduleId? || typeof moduleId isnt "string"
        throw new Error "Bronson.Core#stopModule: moduleId must be valid"
  
      if not @modules[moduleId]?
        throw new Error "Bronson.Core#stopModule: that moduleId is not loaded"
  
      try 
        require.undef(moduleId) 
        @unsubscribeAll(moduleId) 
  
      catch e
        throw new Error "Bronson.Core#stopModule: #{e}"
     
      callback()
  
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
  
    # Cleanup this controller
    # 
    # @example
    #   @dipose()
    #
    dispose: ->
      return if @disposed
  
      # Dispose and delete all members which are disposable
      # for own prop of this
      #   obj = this[prop]
      #   if obj and typeof obj.dispose is 'function'
      #     obj.dispose()
      #     delete this[prop]
  
      # Stop this module and remove all events
      Bronson.Core.stopModule @id, ->
  
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
            object[key] = extend object[key], val
  
      object
  
  

  # Just return a value to define the module export.
  # This example returns an object, but the module
  # can return a function as the exported value.
  return Bronson