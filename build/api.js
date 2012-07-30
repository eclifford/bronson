
(function() {
  var __slice = Array.prototype.slice;

  define('test',[], function() {
    var Test;
    return Test = {
      _debug: true,
      debug: function(on_) {
        return this._debug = (on_ ? true : false);
      },
      log: function() {
        var message, severity;
        severity = arguments[0], message = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (this._debug) {
          if (message[1]) {
            return console[(severity === 1 ? "log" : (severity === 2 ? "warn" : "error"))](message[0], message[1]);
          } else {
            return console[(severity === 1 ? "log" : (severity === 2 ? "warn" : "error"))](message[0]);
          }
        } else {

        }
      }
    };
  });

}).call(this);

(function() {
  var __slice = Array.prototype.slice;

  define('api',['test'], function() {
    var Logger;
    return Logger = {
      _debug: true,
      debug: function(on_) {
        return this._debug = (on_ ? true : false);
      },
      log: function() {
        var message, severity;
        severity = arguments[0], message = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (this._debug) {
          if (message[1]) {
            return console[(severity === 1 ? "log" : (severity === 2 ? "warn" : "error"))](message[0], message[1]);
          } else {
            return console[(severity === 1 ? "log" : (severity === 2 ? "warn" : "error"))](message[0]);
          }
        } else {

        }
      }
    };
  });

}).call(this);
