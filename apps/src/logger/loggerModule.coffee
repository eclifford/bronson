define [
  'jquery',
  'bronson'
], ($, Bronson) ->
  class Logger extends Bronson.Module
    constructor: (parameters={}) ->
      @el = parameters.el
      super

    load: ->     
      # Listen for all global events
      Bronson.Api.subscribe 'logger', 'logevent', (event) =>
        $(@el).append "<div>#{event.msg}</div>"

      # Example of how you could notify other modules you've loaded
      Bronson.Api.publish 'moduleLoaded', { type: 'Logger', id: @id }

    start: ->
      $(@el).html('Log Events');

    stop: ->
      $(@el).empty();

    unload: ->
      # Clean up the event
      Bronson.Api.unsubscribe('logger', 'logevent');