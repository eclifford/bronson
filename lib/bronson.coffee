((root, factory) ->
  if typeof define is "function" and define.amd
    # AMD. Register as an anonymous module.
    define [], factory()
  else   
    # Browser globals
    root.Bronson = factory()
) this, () ->
  Bronson = window.Bronson = 
    version: "1.0.0"
    debug: false

    events: {}
    modules: {}

    # Publish an event to it's subscribers
    # @param event [String] the event the publish in the form of
    #   channel:topic
    #
    # @example
    #   Bronson.publish 'grid:change'
    #
    publish: (event) ->
       # subscriber or subscriber:channel:event
      _event_regex = /^[a-z]+((:[a-z]+){1})$/
      _event = event.toLowerCase()

      # validate params
      if !_event_regex.test(_event)
        throw new Error "Bronson.publish: event #{_event} must be in format subscriber or channel:topic"

      # split event based on channel:event
      _event_array = _event.split(':')

      # store array in channel:event
      _channel = _event_array[0]
      _topic = _event_array[1]

      # Verify that the event exists
      if !@events[_channel][_topic]
        return true

      # Get all subscribers to this event
      _subscribers = @events[_channel][_topic].slice()

      # Get the arguments
      _args = [].slice.call(arguments, 1)

      # Call the callback method on all subscribers
      for subscriber in _subscribers
        subscriber.callback.apply this, _args

      if @debug 
        console.log "Bronson.publish: #{_event}"

    # Subscribe a module to an event
    #
    # @param event [String] the event string
    # @param callback [Function] the method to invoke 
    # @param context [Object] what 'this' is
    #
    # @example
    #   Bronson.subscribe 'searchview:grid:change', ->
    #     console.log 'woot'
    #
    subscribe: (event, callback, context) -> 
      # subscriber or subscriber:channel:event
      _event_regex = /^[a-z]+((:[a-z]+){2})$/
      _event = event.toLowerCase()

      # validate params
      if !_event_regex.test(_event)
        throw new Error "Bronson.subscribe: event #{_event} must be in format subscriber or subscriber:channel:topic"
      if callback? and typeof callback isnt "function"
        throw new Error "Bronson.subscribe: callback must be a function"   

      # split event based on subscriber:channel:event
      _event_array = _event.split(':')

      # store array in subsciber:channel:event
      _subscriber = _event_array[0]
      _channel = _event_array[1]
      _topic = _event_array[2]

      # verify if this subscription is permitted
      if Bronson.Permissions.enabled
        if !Bronson.Permissions.rules[_subscriber][_channel]
          throw new Error "Bronson#.subscribe: attempting to subscribe to channel #{_channel} which is not permmitted by current permissions"

      # if change doesn't exist create it
      if not @events[_channel]
        @events[_channel] = {}

      # Create the event if it doesn't exist otherwise select it
      @events[_channel][_topic] = (if (not @events[_channel][_topic]) then [] else @events[_channel][_topic])

      # Push the event
      @events[_channel][_topic].push 
        subscriber: _subscriber
        context: context || this
        callback: callback

      if @debug 
        console.log "Bronson.subscribe: #{_event}"

    # Unsubscribe a subscriber from a event
    # @param event [String] the event string
    # 
    # @example
    #   Bronson.unsubscribe 'searchview:grid:change'
    #
    unsubscribe: (event) ->    
      # subscriber or subscriber:channel:event
      _event_regex = /^[a-z]+((:[a-z]+){2})?$/
      _event = event.toLowerCase()

      if !_event_regex.test(_event)
        throw new Error "Bronson.unsubscribe: event #{_event} must be in format subscriber or subscriber:channel:topic"

      # split event based on subscriber:channel:event
      _event_array = _event.split(':')

      # if typeof event_array isnt "array" and (event_array.length isnt 3 or event_array.length isnt 1)
      #   throw new Error "Bronson#unsubscribe: event must be supplied in the form of subscriber:channel:topic"

      # store array in subsciber:channel:event
      _subscriber = _event_array[0]
      _channel = _event_array[1]
      _topic = _event_array[2] 

      # if only subscriber passed we remove all events 
      if _event_array.length == 1
        for _channel of @events
          for _topic of @events[_channel]
            for item, i in @events[_channel][_topic]
              if item.subscriber == _subscriber  
                @events[_channel][_topic].splice i, 1            
                break
      else
        # remove the subscribed event
        for item, i in @events[_channel][_topic]
          if item.subscriber == _subscriber
            @events[_channel][_topic].splice i, 1 
            return
     
    # Load a module
    #
    # @param module [String] the AMD module to load(alias or relative path)
    # @param config [Object] whether or not to autostart the module
    # @param callback [Function] (optional) the callback to invoke upon module load
    # @param autostart [Boolean] (optional) whether or not to start the module on load
    #
    # @example
    #   Bronson.load 'example', { el: '#test' }, ->
    #     console.log 'loaded!'
    #   , true
    #
    load: (module, config, callback, autostart=true) -> 
      # Verify the input paramaters
      if not module? || typeof module isnt 'string'
        throw new Error "Bronson.load: must supply a valid module"

      if callback? and typeof callback isnt 'function'
        throw new Error "Bronson.load: callback must be in the form of a function"

      if autostart? and typeof autostart isnt 'boolean'
        throw new Error "Bronson.load: autostart must be a valid boolean"

      # Load the module through RequireJS
      require ['module', module], (Module, LoadedModule) =>
        try 
          _module = new LoadedModule(config)
          _module.id = Module.id

          # Create the module if it doesn't exist otherwise select it
          @modules[module] = (if (not @modules[module]) then [] else @modules[module])

          # Store the loaded module
          @modules[module].push _module

          # Load the module
          _module.load()

          window.module = _module

          # Start the module if specified
          _module.start() if autostart

          # Return a reference to the module we added
          callback(_module)
        catch e 
          throw new Error "Bronson.load: #{e}"
      , (err) ->
        if err.requireType == 'timeout'
          throw new Error 
        else
          failedId = err.requireModules && err.requireModules[0]
          require.undef(failedId)
          throw err 

    # Unload module
    #
    # @example
    #   Bronson.unload 'TestModule'
    #
    unload: (id) ->
      # Validate input parameters
      if not id? || typeof id isnt "string"
        throw new Error "Bronson.unload: id must be valid"

      try 
        for module of @modules
          if @modules.hasOwnProperty(module) 
            for instance, y in @modules[module]
              if instance.id == id
                instance.unload()
                @modules[module].splice y, 1
                return

        if @modules[module].length == 0
          require.undef module
          delete @modules[module]

        contextMap = require.s.contexts._.defined

        for key in contextMap
          if contextMap.hasOwnProperty(key) && key.indexOf(channel) != -1
            require.undef(key)

      catch e
        throw new Error "Bronson.unload: #{e}"

    # Unload all modues
    #
    # @example
    #   Bronson.unloadAll()
    #
    unloadAll: () ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance in @modules[module]
            @unloadModule instance.id

    # startModule
    # A module by default may not be started and may need done so manually
    #
    # @param @id [string] The RequireJS id of the loaded module instance
    #
    # @example
    #   Bronson.start 'TestModule'
    #
    start: (id) ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance, y in @modules[module]
            if instance.id == id
              instance.start()
              return

    # stopModule
    # A module may be stopped manually
    # 
    # param @id [string] The RequireJS id of the loaded module instance
    #
    stop: (id) ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance in @modules[module]
            if instance.id == id
              instance.stop()
              return

    # stopAllModules
    # Stop all instanced modules
    #
    stopAll: () ->
      for module of @modules
        if @modules.hasOwnProperty(module) 
          for instance in @modules[module]
            instance.stop()

  # Aliases
  Bronson.on      = Bronson.subscribe
  Bronson.trigger = Bronson.publish

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
        throw new Error 'Bronson.Permissions.validate: must provide a valid subscriber'
      if not channel? || typeof channel isnt 'string'
        throw new Error 'Bronson.Permissions.validate: must provide a valid channel' 
       
      if @enabled 
        test = @rules[subscriber]?[channel]
        return if test is undefined then false else test
      else 
        return true

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
      throw new Error "Bronson.Module.initialize: must override initialize"

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

  return Bronson