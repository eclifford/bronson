R8 = window.R8 =
  version: "0.0.1"

# Utility function watching for RequireJS errors
# @ param err [String] the error 
#
require.onError = (err) ->
  if err.requireType is 'timeout'
    console.error "Could not load module #{err.requireModules}"
  else
    failedId = err.requireModules && err.requireModules[0]
    require.undef failedId
    throw err