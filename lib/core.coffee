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
