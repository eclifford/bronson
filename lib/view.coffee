# Backbone Base View
# Base view for extending shared backbone functionality
#
# @author Eric Clifford
# @version 1.0.0
# @copyright AKQA
# @todo 
#

class Bronson.View extends Backbone.View
  # Subviews
  # --------

  # List of subviews
  subviews: null
  subviewsByName: null

  constructor: ->
    # Call Backbone’s constructor
    super

  initialize: (options) ->
    # No super call here, Backbone’s `initialize` is a no-op

    # Initialize subviews
    @subviews = []
    @subviewsByName = {}

    logger.log 1, "--- View: initialize()" 

  # Subviews
  # --------

  # Getting or adding a subview
  subview: (name, view) ->
    if name and view
      # Add the subview, ensure it’s unique
      @removeSubview name
      @subviews.push view
      @subviewsByName[name] = view
      view
    else if name
      # Get and return the subview by the given name
      @subviewsByName[name]

    logger.log 1, "--- View: subview(#{name})" 

  # Removing a subview
  removeSubview: (nameOrView) ->
    return unless nameOrView

    if typeof nameOrView is 'string'
      # Name given, search for a subview by name
      name = nameOrView
      view = @subviewsByName[name]
    else
      # View instance given, search for the corresponding name
      view = nameOrView
      for otherName, otherView of @subviewsByName
        if view is otherView
          name = otherName
          break

    # Break if no view and name were found
    return unless name and view and view.dispose

    # Dispose the view
    view.dispose()

    # Remove the subview from the lists
    index = _(@subviews).indexOf(view)
    if index > -1
      @subviews.splice index, 1
    delete @subviewsByName[name]

    logger.log 1, "--- View: removeSubView(#{nameOrView})" 

  # Main render function
  # This method is bound to the instance in the constructor (see above)
  render: ->
    throw new Error 'View#render must be overridden'

  # Disposal
  # --------

  disposed: false

  dispose: ->
    return if @disposed

    # Dispose subviews
    subview.dispose() for subview in @subviews

    # Remove the topmost element from DOM. This also removes all event
    # handlers from the element and all its children.
    @$el.remove()

    # Remove element references, options,
    # model/collection references and subview lists
    properties = [
      'el', '$el',
      'options', 'model', 'collection',
      'subviews', 'subviewsByName',
      '_callbacks'
    ]
    delete this[prop] for prop in properties

    # Finished
    @disposed = true

    Object.freeze? this

    logger.log 1, "--- View: dispose()" 