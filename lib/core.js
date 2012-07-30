(function() {
  var Core,
    __slice = Array.prototype.slice;

  Core = R8.Core = {
    channels: {},
    modules: {},
    subscribe: function(subscriber, channel, callback) {
      if (!(subscriber != null) || !(channel != null) || !(callback != null)) {
        throw new Error('R8.Core#subscribe: subscriber, channel, callback must be defined');
      }
      if (typeof channel !== "string") {
        throw new Error("R8.Core#subscribe: channel must be a string");
      }
      if (typeof subscriber !== "string") {
        throw new Error("R8.Core#subscribe: subscriber must be a string");
      }
      if (typeof callback !== "function") {
        throw new Error("R8.Core#subscribe: callback must be a function");
      }
      this.channels[channel] = (!this.channels[channel] ? [] : this.channels[channel]);
      this.channels[channel].push({
        subscriber: subscriber,
        callback: callback
      });
      return console.log("Core#subscribe: Subscribing subscriber: " + subscriber + " to channel: " + channel);
    },
    unsubscribe: function(subscriber, channel) {
      var i, item, _len, _ref, _results;
      _ref = channels[channel];
      _results = [];
      for (i = 0, _len = _ref.length; i < _len; i++) {
        item = _ref[i];
        if (item.subscriber === subscriber) {
          _results.push(channels[channel].splice(i, 1));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    publish: function(channel) {
      var args, subscriber, subscribers, _i, _len, _results;
      if (!(channel != null)) {
        throw new Error("Core#publish: channel must be defined");
      }
      if (typeof channel !== "string") {
        throw new Error("Core#publish: channel must be a string");
      }
      if (!this.channels[channel]) return true;
      subscribers = this.channels[channel].slice();
      args = [].slice.call(arguments, 1);
      _results = [];
      for (_i = 0, _len = subscribers.length; _i < _len; _i++) {
        subscriber = subscribers[_i];
        subscriber.callback.apply(this, args);
        _results.push(console.log("Core#publish: Publishing event to " + channel));
      }
      return _results;
    },
    createModule: function() {
      var callback, moduleId, obj, _i;
      moduleId = arguments[0], obj = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
      if (moduleId === 'undefined') {
        throw new Error("Core#createModule: moduleId must be defined");
      }
      if (typeof moduleId !== 'string') {
        throw new Error("Core#createModule: moduleId must be a string");
      }
      obj = obj[0];
      return require([moduleId], function(module) {
        module = new module(obj);
        modules[moduleId] = module;
        callback(module);
        return console.log("Core#createModule: Creating module " + moduleId + " successful");
      });
    },
    stopAllModules: function() {
      var id, _results;
      _results = [];
      for (id in modules) {
        _results.push(this.stopModule(id));
      }
      return _results;
    },
    stopModule: function(moduleId) {
      var ch, i, mod;
      mod = modules[moduleId];
      if (mod) {
        for (ch in this.channels) {
          if (this.channels.hasOwnProperty(ch)) {
            i = 0;
            while (i < this.channels[ch].length) {
              if (this.channels[ch][i].subscriber === moduleId) {
                this.channels[ch].splice(i);
              }
              i++;
            }
          }
        }
        return console.log("AKQA.Application.Core#stopModule: successfully stopped module " + moduleId);
      } else {
        throw new Error("AKQA.Application.Core#stopModule: unable to stop nonexistent module");
      }
    }
  };

}).call(this);
