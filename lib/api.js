(function() {
  var Api,
    __slice = Array.prototype.slice;

  Api = R8.Api = {
    subscribe: function(subscriber, channel, callback) {
      if (Permissions.validate(subscriber, channel)) {
        return Core.subscribe(subscriber, channel, callback);
      } else {
        return console.error("Core#subscribe: Subscriber " + subscriber + " not allowed to listen on channel " + channel);
      }
    },
    unsubscribe: function(subscriber, channel) {
      return Core.unsubscribe(subscriber, channel);
    },
    publish: function(channel) {
      return Core.publish(channel);
    },
    createModule: function() {
      var callback, moduleId, obj, _i;
      moduleId = arguments[0], obj = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
      return Core.createModule(moduleId, obj, callback);
    },
    stopAllModules: function() {
      return Core.stopAllModules();
    },
    stopModule: function(moduleId) {
      return Core.stopModule(moduleId);
    }
  };

}).call(this);
