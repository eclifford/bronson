# Bronson Api
# Interface layer for Bronson
#
# @author Eric Clifford
# @version 0.0.1
#
Api = Bronson.Api = 
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
    Bronson.Core.createModule moduleId, obj, callback

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