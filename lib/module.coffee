class Bronson.Module
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