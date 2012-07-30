(function() {
  var R8;

  R8 = window.R8 = {
    version: "0.0.1"
  };

  require.onError = function(err) {
    var failedId;
    if (err.requireType === 'timeout') {
      return console.error("Could not load module " + err.requireModules);
    } else {
      failedId = err.requireModules && err.requireModules[0];
      require.undef(failedId);
      throw err;
    }
  };

}).call(this);
