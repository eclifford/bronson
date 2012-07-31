class R8.Model extends Backbone.Model
  disposed: false

  dispose: ->
    return if @disposed

    # Remove the collection reference, internal attribute hashes
    # and event handlers
    properties = [
      'collection',
      'attributes', 'changed'
      '_escapedAttributes', '_previousAttributes',
      '_silent', '_pending',
      '_callbacks'
    ]
    delete this[prop] for prop in properties

    # Finished
    @disposed = true

    Object.freeze? this