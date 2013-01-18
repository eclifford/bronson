//   BronsonJS - v1.0.0 - 2013-01-17
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
        var args, channel, event_array, event_regex, subscriber, subscribers, topic, _i, _len, _results;
        event_regex = /^[a-z]+((:[a-z]+){1})$/;
        if (!event_regex.test(event)) {
          throw new Error("Bronson.publish: event must be in format subscriber or subscriber:channel:topic");
        }
        event_array = event.toLowerCase().split(':');
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
        var channel, event_array, event_regex, subscriber, topic;
        event_regex = /^[a-z]+((:[a-z]+){2})$/;
        if (!event_regex.test(event)) {
          throw new Error("Bronson.subscribe: event must be in format subscriber or subscriber:channel:topic");
        }
        if ((callback != null) && typeof callback !== "function") {
          throw new Error("Bronson.subscribe: callback must be a function");
        }
        event_array = event.toLowerCase().split(':');
        subscriber = event_array[0];
        channel = event_array[1];
        topic = event_array[2];
        if (Bronson.Permissions.enabled) {
          if (!Bronson.Permissions.rules[subscriber][channel]) {
            throw new Error("Bronson#.subscribe: attempting to subscribe to unpermitted channel");
          }
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
        var channel, event_array, event_regex, i, item, subscriber, topic, _channel, _i, _len, _ref, _results, _topic;
        event_regex = /^[a-z]+((:[a-z]+){2})?$/;
        if (!event_regex.test(event)) {
          throw new Error("Bronson.unsubscribe: event must be in format subscriber or subscriber:channel:topic");
        }
        event_array = event.toLowerCase().split(':');
        subscriber = event_array[0];
        channel = event_array[1];
        topic = event_array[2];
        if (event_array.length === 1) {
          _results = [];
          for (_channel in this.events) {
            _results.push((function() {
              var _results1;
              _results1 = [];
              for (_topic in this.events[_channel]) {
                _results1.push((function() {
                  var _i, _len, _ref, _results2;
                  _ref = this.events[_channel][_topic];
                  _results2 = [];
                  for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
                    item = _ref[i];
                    if (item.subscriber === subscriber) {
                      _results2.push(this.events[_channel][_topic].splice(i, 1));
                    } else {
                      _results2.push(void 0);
                    }
                  }
                  return _results2;
                }).call(this));
              }
              return _results1;
            }).call(this));
          }
          return _results;
        } else {
          _ref = this.events[channel][topic];
          for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
            item = _ref[i];
            if (item.subscriber === subscriber) {
              this.events[channel][topic].splice(i, 1);
              return;
            }
          }
        }
      },
      load: function(module, config, callback, autostart) {
        var _this = this;
        if (autostart == null) {
          autostart = true;
        }
        if (!(module != null) || typeof module !== 'string') {
          throw new Error("Bronson.Core#loadModule: must supply a valid module");
        }
        if ((callback != null) && typeof callback !== 'function') {
          throw new Error("Bronson.load: callback must be in the form of a function");
        }
        if ((autostart != null) && typeof autostart !== 'boolean') {
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
            window.module = _module;
            if (autostart) {
              _module.start();
            }
            return callback(_module);
          } catch (e) {
            throw new Error("Bronson.Core#loadModule: " + e);
          }
        }, function(err) {
          var failedId;
          if (err.requireType === 'timeout') {
            throw new Error;
          } else {
            failedId = err.requireModules && err.requireModules[0];
            require.undef(failedId);
            throw err;
          }
        });
      },
      unload: function(id) {
        var contextMap, instance, key, module, y, _i, _j, _len, _len1, _ref, _results;
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
            delete this.modules[module];
          }
          contextMap = require.s.contexts._.defined;
          _results = [];
          for (_j = 0, _len1 = contextMap.length; _j < _len1; _j++) {
            key = contextMap[_j];
            if (contextMap.hasOwnProperty(key) && key.indexOf(channel) !== -1) {
              _results.push(require.undef(key));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
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
