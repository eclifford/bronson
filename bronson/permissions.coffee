# Bronson Permissions 
# Permissions layer for Bronson
#
# @author Eric Clifford
# @version 0.1.0
#
Permissions = Bronson.Permissions =
  # Whether or not the permissions are activated
  enabled: false

  # Application rules
  rules: {}

  # Overwrite the application rules
  set: (props) ->
    @rules = Bronson.Util.extend(@rules, props)

  # Validate a subscribers permission for subscribing to a channel
  #
  # @param subscriber [string] the subscriber 
  # @param channel [string] the channel
  #
  validate: (subscriber, channel) ->
    # Validate inputs
    if not subscriber? || typeof subscriber isnt 'string'
      throw new Error 'Bronson.Permissions#validate: must provide a valid subscriber'
    if not channel? || typeof channel isnt 'string'
      throw new Error 'Bronson.Permissions#validate: must provide a valid channel' 
     
    if @enabled 
      test = @rules[subscriber]?[channel]
      return if test is undefined then false else test
    else 
      return true