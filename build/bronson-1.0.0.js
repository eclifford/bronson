//   BronsonJS - v1.0.0 - 2013-01-15
//   http://github.com/eclifford/bronson/
//   Copyright (c) 2013 Eric Clifford; Licensed MIT

(function() {
  var __slice = [].slice,
    __hasProp = {}.hasOwnProperty;

  (function(root, factory) {
    if (typeof define === "function" && define.amd) {
      return define([], factory());
    } else {
      return root.Bronson = factory();
    }
  })(this, function() {
    var Bronson, Permissions, Util;
    Bronson = window.Bronson = {
      version: "1.0.0",
      events: {},
      modules: {},
      publish: function(event) {
        var args, channel, event_array, subscriber, subscribers, topic, _i, _len, _results;
        if (!(event != null) || typeof event !== "string") {
          throw new Error("Bronson#publish: must supply a valid event");
        }
        event_array = event.toLowerCase().split(':');
        if (typeof event_array !== "array" && event_array.length !== 2) {
          throw new Error("Bronson#publish: event must be supplied in the form of subscriber:channel:topic");
        }
        channel = event_array[0];
        topic = event_array[1];
        if (!this.events[channel][topic]) {
          return true;
        }
        subscribers = this.events[channel][topic].slice();
        args = [].slice.call(arguments, 1);
        _results = [];
        for (_i = 0, _len = subscribers.length; _i < _len; _i++) {
          subscriber = subscribers[_i];
          _results.push(subscriber.callback.apply(this, args));
        }
        return _results;
      },
      subscribe: function(event, callback, context) {
        var channel, event_array, subscriber, topic;
        if (!(event != null) || typeof event !== "string") {
          throw new Error("Bronson#subscribe: must supply a valid event");
        }
        event_array = event.toLowerCase().split(':');
        if (typeof event_array !== "array" && event_array.length !== 3) {
          throw new Error("Bronson#subscribe: event must be supplied in the form of subscriber:channel:topic");
        }
        subscriber = event_array[0];
        channel = event_array[1];
        topic = event_array[2];
        if ((callback != null) && typeof callback !== "function") {
          throw new Error("Bronson.Core#subscribe: callback must be a function");
        }
        if (!this.events[channel]) {
          this.events[channel] = {};
        }
        this.events[channel][topic] = (!this.events[channel][topic] ? [] : this.events[channel][topic]);
        return this.events[channel][topic].push({
          subscriber: subscriber,
          context: context || this,
          callback: callback
        });
      },
      unsubscribe: function(event) {
        var channel, event_array, i, item, subscriber, topic, _i, _len, _ref, _results;
        if (!(event != null) || typeof event !== "string") {
          throw new Error("Bronson#unsubscribe: must supply a valid event");
        }
        event_array = event.toLowerCase().split(':');
        if (typeof event_array !== "array" && event_array.length !== 3) {
          throw new Error("Bronson#unsubscribe: event must be supplied in the form of subscriber:channel:topic");
        }
        subscriber = event_array[0];
        channel = event_array[1];
        topic = event_array[2];
        _ref = this.events[channel][topic];
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          item = _ref[i];
          if (item.subscriber === subscriber) {
            _results.push(this.events[channel][topic].splice(i, 1));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      unsubscribeAll: function(subscriber) {
        var event, len, _results;
        _results = [];
        for (event in this.events) {
          if (this.events.hasOwnProperty(event)) {
            len = this.events[event].length;
            while (len--) {
              if (this.events[event][len].subscriber === subscriber) {
                this.events[event].splice(len, 1);
              }
            }
            if (this.events[event].length === 0) {
              _results.push(delete this.events[event]);
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      load: function(module, config, callback) {
        var _this = this;
        if (!(module != null) || typeof module !== 'string') {
          throw new Error("Bronson.Core#loadModule: must supply a valid module");
        }
        if ((typeof autostart !== "undefined" && autostart !== null) && typeof autostart !== 'boolean') {
          throw new Error("Bronson.Core#loadModule: autostart must be a valid boolean");
        }
        return require(['module', module], function(Module, LoadedModule) {
          var _module;
          try {
            _module = new LoadedModule(config);
            _module.id = Module.id;
            _this.modules[module] = (!_this.modules[module] ? [] : _this.modules[module]);
            _this.modules[module].push(_module);
            _module.load();
            return callback(_module);
          } catch (e) {
            throw new Error("Bronson.Core#loadModule: " + e);
          }
        });
      },
      unload: function(id) {
        var instance, module, y, _i, _len, _ref;
        if (!(id != null) || typeof id !== "string") {
          throw new Error("Bronson.Core#unloadModule: id must be valid");
        }
        try {
          for (module in this.modules) {
            if (this.modules.hasOwnProperty(module)) {
              _ref = this.modules[module];
              for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
                instance = _ref[y];
                if (instance.id === id) {
                  instance.unload();
                  this.unsubscribeAll(id);
                  this.modules[module].splice(y, 1);
                  return;
                }
              }
            }
          }
          if (this.modules[module].length === 0) {
            require.undef(module);
            return delete this.modules[module];
          }
        } catch (e) {
          throw new Error("Bronson.Core#unloadModule: " + e);
        }
      },
      unloadAll: function() {
        var instance, module, _results;
        _results = [];
        for (module in this.modules) {
          if (this.modules.hasOwnProperty(module)) {
            _results.push((function() {
              var _i, _len, _ref, _results1;
              _ref = this.modules[module];
              _results1 = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                instance = _ref[_i];
                _results1.push(this.unloadModule(instance.id));
              }
              return _results1;
            }).call(this));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      start: function(id) {
        var instance, module, y, _i, _len, _ref;
        for (module in this.modules) {
          if (this.modules.hasOwnProperty(module)) {
            _ref = this.modules[module];
            for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
              instance = _ref[y];
              if (instance.id === id) {
                instance.start();
                return;
              }
            }
          }
        }
      },
      stop: function(id) {
        var instance, module, _i, _len, _ref;
        for (module in this.modules) {
          if (this.modules.hasOwnProperty(module)) {
            _ref = this.modules[module];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              instance = _ref[_i];
              if (instance.id === id) {
                instance.stop();
                return;
              }
            }
          }
        }
      },
      stopAll: function() {
        var instance, module, _results;
        _results = [];
        for (module in this.modules) {
          if (this.modules.hasOwnProperty(module)) {
            _results.push((function() {
              var _i, _len, _ref, _results1;
              _ref = this.modules[module];
              _results1 = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                instance = _ref[_i];
                _results1.push(instance.stop());
              }
              return _results1;
            }).call(this));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };
    Bronson.on = Bronson.subscribe;
    Bronson.trigger = Bronson.publish;
    Util = Bronson.Util = {
      extend: function() {
        var extenders, key, object, other, val, _i, _len;
        object = arguments[0], extenders = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (!(object != null)) {
          return {};
        }
        for (_i = 0, _len = extenders.length; _i < _len; _i++) {
          other = extenders[_i];
          for (key in other) {
            if (!__hasProp.call(other, key)) continue;
            val = other[key];
            if (!(object[key] != null) || typeof val !== "object") {
              object[key] = val;
            } else {
              object[key] = this.extend(object[key], val);
            }
          }
        }
        return object;
      }
    };
    Permissions = Bronson.Permissions = {
      enabled: false,
      rules: {},
      set: function(props) {
        return this.rules = Bronson.Util.extend(this.rules, props);
      },
      validate: function(subscriber, channel) {
        var test, _ref;
        if (!(subscriber != null) || typeof subscriber !== 'string') {
          throw new Error('Bronson.Permissions#validate: must provide a valid subscriber');
        }
        if (!(channel != null) || typeof channel !== 'string') {
          throw new Error('Bronson.Permissions#validate: must provide a valid channel');
        }
        if (this.enabled) {
          test = (_ref = this.rules[subscriber]) != null ? _ref[channel] : void 0;
          if (test === void 0) {
            return false;
          } else {
            return test;
          }
        } else {
          return true;
        }
      }
    };
    Bronson.Module = (function() {

      Module.prototype.id = "";

      Module.prototype.disposed = false;

      Module.prototype.started = false;

      function Module() {}

      Module.prototype.load = function() {
        throw new Error("Bronson.Module#initialize: must override initialize");
      };

      Module.prototype.start = function() {
        return this.started = true;
      };

      Module.prototype.stop = function() {
        return this.started = false;
      };

      Module.prototype.unload = function() {
        if (this.disposed) {
          return;
        }
        this.disposed = true;
        return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
      };

      return Module;

    })();
    return Bronson;
  });

}).call(this);
