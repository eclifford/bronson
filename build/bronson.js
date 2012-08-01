  (function(root, factory) {
    if (typeof define === "function" && define.amd) {
      return define([], factory);
    } else {
      return root.Bronson = factory(root.b);
    }
  })(this, function() {
    var Api, Bronson, Core, Permissions, Util;
    Bronson = window.Bronson = {
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
    requirejs.onResourceLoad = function(context, map, depArray) {};
    Api = Bronson.Api = {
      publish: function(channel) {
        if (!(channel != null) || typeof channel !== "string") {
          throw new Error("Bronson.Api#publish: a valid channel must be supplied");
        }
        return Bronson.Core.publish(channel, arguments[1]);
      },
      subscribe: function(subscriber, channel, callback) {
        if (!(subscriber != null) || typeof subscriber !== "string") {
          throw new Error("Bronson.Api#subscribe: a valid subscriber must be supplied");
        }
        if (!(channel != null) || typeof channel !== "string") {
          throw new Error("Bronson.Api#subscribe: a valid channel must be supplied");
        }
        if ((callback != null) && typeof callback !== "function") {
          throw new Error("Bronson.Api#subscribe: callback must be a function");
        }
        if (Permissions.validate(subscriber, channel)) {
          return Bronson.Core.subscribe(subscriber, channel, callback);
        } else {
          throw new Error("Bronson.Api#subscribe: Subscriber " + subscriber + " not allowed to listen on channel " + channel);
        }
      },
      unsubscribe: function(subscriber, channel) {
        if (!(subscriber != null) || typeof subscriber !== "string") {
          throw new Error("Bronson.Api#unsubscribe: a valid subscriber must be supplied");
        }
        if (!(channel != null) || typeof channel !== "string") {
          throw new Error("Bronson.Api#unsubscribe: a valid channel must be supplied");
        }
        return Bronson.Core.unsubscribe(subscriber, channel);
      },
      createModule: function() {
        var callback, moduleId, obj, _i;
        moduleId = arguments[0], obj = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
        if (!moduleId || typeof moduleId !== "string") {
          throw new Error("Bronson.Api#createModule: a valid module alias or path must be supplied");
        }
        if ((callback != null) && typeof callback !== "function") {
          throw new Error("Bronson.Api#createModule: callback must be a function");
        }
        return Bronson.Core.createModule(moduleId, obj, callback);
      },
      stopAllModules: function() {
        return Bronson.Core.stopAllModules();
      },
      stopModule: function(moduleId, callback) {
        if (!moduleId || typeof moduleId !== "string") {
          throw new Error("Bronson.Api#stopModule: a valid module alias or path must be supplied");
        }
        if ((callback != null) && typeof callback !== "function") {
          throw new Error("Bronson.Api#stopModule: callback must be a function");
        }
        return Bronson.Core.stopModule(moduleId, callback);
      }
    };
    Permissions = Bronson.Permissions = {
      enabled: false,
      rules: {},
      extend: function(props) {
        var rules;
        return rules = Bronson.Util.extend(rules, props);
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
      channels: {},
      modules: {},
      publish: function(channel) {
        var args, subscriber, subscribers, _i, _len, _results;
        if (!(channel != null)) {
          throw new Error("Bronson.Core#publish: channel must be defined");
        }
        if (typeof channel !== "string") {
          throw new Error("Bronson.Core#publish: channel must be a string");
        }
        if (!this.channels[channel]) {
          return true;
        }
        subscribers = this.channels[channel].slice();
        args = [].slice.call(arguments, 1);
        _results = [];
        for (_i = 0, _len = subscribers.length; _i < _len; _i++) {
          subscriber = subscribers[_i];
          _results.push(subscriber.callback.apply(this, args));
        }
        return _results;
      },
      subscribe: function(subscriber, channel, callback) {
        if (!(subscriber != null) || typeof subscriber !== "string") {
          throw new Error("Bronson.Core#subscribe: must supply a valid subscriber");
        }
        if (!(channel != null) || typeof channel !== "string") {
          throw new Error("Bronson.Core#subscribe: must supply a valid channel");
        }
        if ((callback != null) && typeof callback !== "function") {
          throw new Error("Bronson.Core#subscribe: callback must be a function");
        }
        this.channels[channel] = (!this.channels[channel] ? [] : this.channels[channel]);
        return this.channels[channel].push({
          subscriber: subscriber,
          callback: callback
        });
      },
      unsubscribe: function(subscriber, channel) {
        var i, item, _i, _len, _ref, _results;
        _ref = this.channels[channel];
        _results = [];
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          item = _ref[i];
          if (item.subscriber === subscriber) {
            _results.push(this.channels[channel].splice(i, 1));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      unsubscribeAll: function(subscriber) {
        var channel, y, _i, _len, _ref, _results;
        _results = [];
        for (channel in this.channels) {
          if (this.channels.hasOwnProperty(channel)) {
            _ref = this.channels[channel];
            for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
              subscriber = _ref[y];
              if (subscriber === subscriber) {
                this.channels[channel].splice(y, 1);
              }
            }
            if (this.channels[channel].length === 0) {
              _results.push(delete this.channels[channel]);
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      createModule: function() {
        var callback, moduleId, obj, _i,
          _this = this;
        moduleId = arguments[0], obj = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
        if (!(moduleId != null)) {
          throw new Error("Bronson.Core#createModule: moduleId must be defined");
        }
        if (typeof moduleId !== 'string') {
          throw new Error("Bronson.Core#createModule: moduleId must be a string");
        }
        obj = obj[0];
        return require([moduleId], function(module) {
          var _module;
          try {
            _module = new module(obj);
            _module.id = moduleId;
            _this.modules[moduleId] = _module;
            return callback(_module);
          } catch (e) {
            throw new Error("Bronson.Core#createModule: " + e);
          }
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
      stopModule: function(moduleId, callback) {
        if (!(moduleId != null) || typeof moduleId !== "string") {
          throw new Error("Bronson.Core#stopModule: moduleId must be valid");
        }
        if (!(this.modules[moduleId] != null)) {
          throw new Error("Bronson.Core#stopModule: that moduleId is not loaded");
        }
        try {
          require.undef(moduleId);
          this.unsubscribeAll(moduleId);
        } catch (e) {
          throw new Error("Bronson.Core#stopModule: " + e);
        }
        return callback();
      }
    };
    Bronson.Module = (function() {

      Module.prototype.id = "";

      Module.prototype.disposed = false;

      function Module() {
        this.initialize.apply(this, arguments);
      }

      Module.prototype.initialize = function() {
        throw new Error("Bronson.Module#initialize: must override initialize");
      };

      Module.prototype.dispose = function() {
        var obj, prop;
        if (this.disposed) {
          return;
        }
        for (prop in this) {
          if (!__hasProp.call(this, prop)) continue;
          obj = this[prop];
          if (obj && typeof obj.dispose === 'function') {
            obj.dispose();
            delete this[prop];
          }
        }
        Bronson.Core.stopModule(id);
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
              object[key] = extend(object[key], val);
            }
          }
        }
        return object;
      }
    };
    return Bronson;
  });