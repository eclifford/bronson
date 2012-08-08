# Bronson Util 
# Permissions layer for Bronson
#
# @author Eric Clifford
# @version 0.0.1
#
Util = Bronson.Util =
  extend: (object, extenders...) ->
    return {} if not object?
    for other in extenders
      for own key, val of other
        if not object[key]? or typeof val isnt "object"
          object[key] = val
        else
          object[key] = @extend object[key], val

    object

