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
    for item, i in channels[channel]
      if item.subscriber == subscriber
        channels[channel].splice i, 1

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

    require [moduleId], (module) ->
      ##try
      # Create the module by instantiating it
      module = new module(obj)          
      modules[moduleId] = module
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




