Permissions = R8.Permissions =
  _enabled: false

  enabled: (value) ->
    @_enabled = !!value

  rules: {}

  extend: (props) ->
    rules = $.extend true, {}, props, @

  # # The rules for modules/events
  # rules:
  #   "gallery-module":
  #     "toggleTray": true
  #     "galleryCloseClicked": true
  #     "changeCurrentPhoto": true
  #   "panel-plugin":
  #     "galleryLoaded": true
  #     "galleryClose": true
  #   "test":
  #     'test': true
  #   "responsive":
  #     "/responsive": true
  #   # "TestModule":
  #   #   "TestEvent": true

  # Validate a subscribers permission for subscribing to a channel
  #
  # @param subscriber [string] the subscriber 
  # @param channel [string] the channel
  #
  validate: (subscriber, channel) ->
    if @_enabled 
      test = @rules[subscriber]?[channel]
      return if test is undefined then false else test
    else 
      return true



