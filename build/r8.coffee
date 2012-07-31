((root, factory) ->
  if typeof define is "function" and define.amd
    # AMD. Register as an anonymous module.
    define [], factory
  else   
    # Browser globals
    root.R8 = factory(root.b)
) this, () ->

  R8 = window.R8 =
    version: "0.0.1"

  # R8 Api
  #
  # @author Eric Clifford
  # @version 0.0.1
  #
  Api = R8.Api = 
    # Subscribe a module to an event
    #
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # @param callback [Function] the callback
    #
    subscribe: (subscriber, channel, callback) -> 
      if Permissions.validate subscriber, channel
        Core.subscribe subscriber, channel, callback
      else 
        console.error "Core#subscribe: Subscriber #{subscriber} not allowed to listen on channel #{channel}"
  
    # Unsubscribe a subscriber from a channel
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # 
    unsubscribe: (subscriber, channel) ->
      Core.unsubscribe subscriber, channel
  
    # Publish an event to a channel
    # @param channel [String] the channel to publish to
    #
    publish: (channel) ->
      Core.publish channel
   
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
    #   core.createModule 'TestModule', {foo: 'bar'}, ->
    #     console.log 'module has been created'
    #
    createModule: (moduleId, obj..., callback) ->  
      Core.createModule moduleId, obj, callback
  
    # Stop all modues
    #
    # @example
    #   core.stopAllModules()
    #
    stopAllModules: ->
      Core.stopAllModules()
  
    # Stop module
    #
    # @example
    #   core.stopModule 'TestModule'
    #
    stopModule: (moduleId)->
      Core.stopModule moduleId
  
  
  Permissions = R8.Permissions =
    _enabled: false
  
    enabled: (value) ->
      @_enabled = !!value
  
    rules: {}
  
    extend: (props) ->
      rules = $.extend true, {}, props, @
  
    # # The rules for modules/events
    # rules:
    #   "gallery-module":
    #     "toggleTray": true
    #     "galleryCloseClicked": true
    #     "changeCurrentPhoto": true
    #   "panel-plugin":
    #     "galleryLoaded": true
    #     "galleryClose": true
    #   "test":
    #     'test': true
    #   "responsive":
    #     "/responsive": true
    #   # "TestModule":
    #   #   "TestEvent": true
  
    # Validate a subscribers permission for subscribing to a channel
    #
    # @param subscriber [string] the subscriber 
    # @param channel [string] the channel
    #
    validate: (subscriber, channel) ->
      if @_enabled 
        test = @rules[subscriber]?[channel]
        return if test is undefined then false else test
      else 
        return true
  
  
  
  
  # R8 Core
  #
  # @author Eric Clifford
  # @version 0.0.1
  #
  Core = R8.Core = 
    channels: {}
    modules: {}
  
    # Subscribe a module to an event
    #
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # @param callback [Function] the callback
    #
    subscribe: (subscriber, channel, callback) -> 
      if not subscriber? or not channel? or not callback?
        throw new Error 'R8.Core#subscribe: subscriber, channel, callback must be defined'
  
      if typeof channel isnt "string"
        throw new Error "R8.Core#subscribe: channel must be a string"
  
      if typeof subscriber isnt "string"
        throw new Error "R8.Core#subscribe: subscriber must be a string"
  
      if typeof callback isnt "function"
        throw new Error "R8.Core#subscribe: callback must be a function"   
  
      # Create the channel if it doesn't exist otherwise select it
      @channels[channel] = (if (not @channels[channel]) then [] else @channels[channel])
  
      @channels[channel].push 
        subscriber: subscriber
        callback: callback
  
      console.log "Core#subscribe: Subscribing subscriber: #{subscriber} to channel: #{channel}"
  
    # Unsubscribe a subscriber from a channel
    # @param subscriber [String] The module to subscribe
    # @param channel [String] The channel to listen on
    # 
    unsubscribe: (subscriber, channel) ->
      for item, i in @channels[channel]
        console.log item, i
        if item.subscriber == subscriber
          @channels[channel].splice i, 1
  
    # Publish an event to a channel
    # @param channel [String] the channel to publish to
    #
    publish: (channel) ->
      if not channel?
        throw new Error "Core#publish: channel must be defined"
  
      if typeof channel isnt "string"
        throw new Error "Core#publish: channel must be a string" 
  
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
        console.log "Core#publish: Publishing event to #{channel}"
   
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
    #   core.createModule 'TestModule', {foo: 'bar'}, ->
    #     console.log 'module has been created'
    #
    createModule: (moduleId, obj..., callback) ->  
      if moduleId is 'undefined'
        throw new Error "Core#createModule: moduleId must be defined"
  
      if typeof moduleId isnt 'string'
        throw new Error "Core#createModule: moduleId must be a string"
  
      obj = obj[0]
  
      require [moduleId], (module) =>
        ##try
        # Create the module by instantiating it
        module = new module(obj)       
  
        @modules['test'] = module
        callback(module)
        console.log "Core#createModule: Creating module #{moduleId} successful"
        ##catch err 
        ##  logger.log 3, "Core#createModule: Error creating module", err
  
    # Stop all modues
    #
    # @example
    #   core.stopAllModules()
    #
    stopAllModules: ->
      for id of modules
        @stopModule id
  
    # Stop module
    #
    # @example
    #   core.stopModule 'TestModule'
    #
    stopModule: (moduleId)->
      mod = modules[moduleId]
      if(mod) 
        for ch of @channels
          if @channels.hasOwnProperty(ch)
            i = 0
            while i < @channels[ch].length
              @channels[ch].splice i  if @channels[ch][i].subscriber is moduleId
              i++
        console.log "AKQA.Application.Core#stopModule: successfully stopped module #{moduleId}"
  
      else 
        throw new Error "AKQA.Application.Core#stopModule: unable to stop nonexistent module"
  
  
  
  
  
  class R8.Module
    view: null
    currentId: null
    disposed: false 
  
    # Constructor
    #
    constructor: ->
      @initialize arguments...
  
    # Initialize
    #
    initialize: ->
      # Empty per default
  
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
  
      # Unbind handlers of global events
      #@unsubscribeAllEvents()
  
      # Remove properties which are not disposable
      properties = ['currentId']
      delete this[prop] for prop in properties
  
      # Finished
      @disposed = true
  
      Object.freeze? this



  # Just return a value to define the module export.
  # This example returns an object, but the module
  # can return a function as the exported value.
  return R8




# # Utility function watching for RequireJS errors
# # @ param err [String] the error 
# #
# require.onError = (err) ->
#   if err.requireType is 'timeout'
#     console.error "Could not load module #{err.requireModules}"
#   else
#     failedId = err.requireModules && err.requireModules[0]
#     require.undef failedId
#     throw err