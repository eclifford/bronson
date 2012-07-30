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

