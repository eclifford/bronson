# Bronson Module
#
# @author Eric Clifford
# @version 0.1.0
#
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
    throw new Error "Bronson.Module#initialize: must override initialize"

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