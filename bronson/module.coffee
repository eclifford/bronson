# Bronson Module
#
# @author Eric Clifford
# @version 0.1.0
#
class Bronson.Module
  id: "" 
  disposed: false 

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
    throw new Error "Bronson.Module#start: must override start"

  # Stop
  #
  stop: ->
    throw new Error "Bronson.Module#stop: must override stop"

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