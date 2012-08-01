# Bronson Collection
# Backbone Collection base class
#
# @author Eric Clifford
# @version 0.0.1
#
class Collection extends Backbone.Collection
  model: Bronson.Model

  # Whether or not this collection has been disposed
  disposed: false

  # Dipose this collection
  # 
  # @example
  #   Bronson.Collection.dispose()
  #
  dispose: ->
    return if @disposed

    # Empty the list silently, but do not dispose all models since
    # they might be referenced elsewhere
    @reset [], silent: true

    # Remove model constructor reference, internal model lists
    # and event handlers
    properties = [
      'model',
      'models', '_byId', '_byCid',
      '_callbacks'
    ]
    delete this[prop] for prop in properties

    # Finished
    @disposed = true

    # Make this object immutable
    Object.freeze? this