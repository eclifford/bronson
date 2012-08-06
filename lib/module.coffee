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