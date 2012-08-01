# Bronson Model
#
# @author Eric Clifford
# @version 0.0.1
#
class Bronson.Model extends Backbone.Model
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

    # Make this object immutable
    Object.freeze? this