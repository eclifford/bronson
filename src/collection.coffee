# Abstract class which extends the standard Backbone collection
# in order to add some functionality
class Collection extends Backbone.Collection
  model: R8.Model

  # Whether or not this collection has been disposed
  disposed: false

  # Dipose this collection
  # 
  # @example
  #   @dipose()
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

    Object.freeze? this