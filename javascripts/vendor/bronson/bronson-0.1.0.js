var __slice = [].slice,
  __hasProp = {}.hasOwnProperty;

(function(root, factory) {
  if (typeof define === "function" && define.amd) {
    return define([], factory());
  } else {
    return root.Bronson = factory();
  }
})(this, function() {
  var Api, Bronson, Core, Permissions, Util;
  Bronson = window.Bronson = {
    version: "0.1.0"
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
  requirejs.onResourceLoad = function(context, map, depArray) {};
  Api = Bronson.Api = {
    publish: function(event) {
      return Bronson.Core.publish(event, arguments[1]);
    },
    subscribe: function(subscriber, event, callback) {
      if (Permissions.validate(subscriber, event)) {
        return Bronson.Core.subscribe(subscriber, event, callback);
      } else {
        throw new Error("Bronson.Api#subscribe: Subscriber " + subscriber + " not allowed to listen on event " + event);
      }
    },
    unsubscribe: function(subscriber, event) {
      return Bronson.Core.unsubscribe(subscriber, event);
    },
    loadModule: function(module, callback, config, autostart) {
      if (config == null) {
        config = {};
      }
      if (autostart == null) {
        autostart = true;
      }
      return Bronson.Core.loadModule(module, config, callback, autostart);
    },
    unloadAllModules: function() {
      return Bronson.Core.unloadAllModules();
    },
    unloadModule: function(moduleId) {
      return Bronson.Core.unloadModule(moduleId, callback);
    },
    startModule: function(id) {
      return Bronson.Core.startModule(moduleId);
    },
    stopModule: function(id) {
      return Bronson.Core.stopModule(moduleId);
    },
    stopAllModules: function() {
      return Bronson.Core.stopAllModules();
    },
    setPermissions: function(permissions) {
      return Bronson.Permissions.set(permissions);
    },
    getModulesInfo: function() {
      return Bronson.Core.modules;
    },
    getEventsInfo: function() {
      return Bronson.Core.events;
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
  Core = Bronson.Core = {
    events: {},
    modules: {},
    publish: function(event) {
      var args, subscriber, subscribers, _i, _len, _results;
      if (!(event != null) || typeof event !== "string") {
        throw new Error("Bronson.Core#publish: must supply a valid event");
      }
      if (!this.events[event]) {
        return true;
      }
      subscribers = this.events[event].slice();
      args = [].slice.call(arguments, 1);
      _results = [];
      for (_i = 0, _len = subscribers.length; _i < _len; _i++) {
        subscriber = subscribers[_i];
        _results.push(subscriber.callback.apply(this, args));
      }
      return _results;
    },
    subscribe: function(subscriber, event, callback) {
      if (!(subscriber != null) || typeof subscriber !== "string") {
        throw new Error("Bronson.Core#subscribe: must supply a valid subscriber");
      }
      if (!(event != null) || typeof event !== "string") {
        throw new Error("Bronson.Core#subscribe: must supply a valid event");
      }
      if ((callback != null) && typeof callback !== "function") {
        throw new Error("Bronson.Core#subscribe: callback must be a function");
      }
      this.events[event] = (!this.events[event] ? [] : this.events[event]);
      return this.events[event].push({
        subscriber: subscriber,
        callback: callback
      });
    },
    unsubscribe: function(subscriber, event) {
      var i, item, _i, _len, _ref;
      _ref = this.events[event];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        item = _ref[i];
        if (item.subscriber === subscriber) {
          this.events[event].splice(i, 1);
          return;
        }
      }
    },
    unsubscribeAll: function(subscriber) {
      var event, y, _i, _len, _ref, _results;
      _results = [];
      for (event in this.events) {
        if (this.events.hasOwnProperty(event)) {
          _ref = this.events[event];
          for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
            subscriber = _ref[y];
            if (subscriber === subscriber) {
              this.events[event].splice(y, 1);
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
    loadModule: function(module, config, callback, autostart) {
      var _this = this;
      if (!(module != null) || typeof module !== 'string') {
        throw new Error("Bronson.Core#loadModule: must supply a valid module");
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
          _this.modules[module].push({
            id: _module.id,
            timeStamp: new Date(),
            started: _module.started,
            disposed: _module.disposed,
            load: _module.load,
            start: _module.start,
            stop: _module.stop,
            unload: _module.unload
          });
          _module.load();
          if (autostart) {
            _module.start();
          }
          return callback(_this.modules[module][_this.modules[module].length - 1]);
        } catch (e) {
          throw new Error("Bronson.Core#loadModule: " + e);
        }
      });
    },
    unloadAllModules: function() {
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
    unloadModule: function(id) {
      var instance, module, y, _i, _len, _ref;
      if (!(id != null) || typeof id !== "string") {
        throw new Error("Bronson.Core#stopModule: id must be valid");
      }
      try {
        for (module in this.modules) {
          if (this.modules.hasOwnProperty(module)) {
            _ref = this.modules[module];
            for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
              instance = _ref[y];
              if (instance.id === id) {
                instance.unload();
                delete this.modules[module][y];
              }
            }
          }
        }
        if (this.modules[module].length === 0) {
          return require.undef(module);
        }
      } catch (e) {
        throw new Error("Bronson.Core#stopModule: " + e);
      }
    },
    startModule: function(id) {
      var instance, module, y, _results;
      _results = [];
      for (module in this.modules) {
        if (this.modules.hasOwnProperty(module)) {
          _results.push((function() {
            var _i, _len, _ref, _results1;
            _ref = this.modules[module];
            _results1 = [];
            for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
              instance = _ref[y];
              if (instance.id === id) {
                _results1.push(instance.start());
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          }).call(this));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    stopModule: function(id) {
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
              if (instance.id === id) {
                _results1.push(instance.stop());
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          }).call(this));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    stopAllModules: function() {
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
              _results1.push(this.stopModule(instance.id));
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
  return Bronson;
});
