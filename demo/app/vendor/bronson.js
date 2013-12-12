/*!
 * Bronsonjs - AMD module framework
 * (c) 2012-2013 Eric Clifford <ericgclifford@gmail.com>
 * MIT Licensed.
 *
 * http://bronsonjs.com
 * http://github.com/eclifford/bronson
 */
(function(root, factory) {
  if (typeof exports !== 'undefined') {
    factory(root, exports);
  } else if (typeof define === 'function' && define.amd) {
    define(['exports'], function(exports) {
      root.Bronson = factory(root, exports);
    });
  } else {
    root.Bronson = factory(root, {});
  }
}(this, function(root, Bronson) {

  // simple deep extend
  var extend = function(target, source) {
    for(var key in source)
      if (key in target) {
        extend(target[key], source[key]);
      }
      else
        target[key] = source[key];
    return target;
  };

  extend(Bronson, {
    version: '2.0.9',

    settings: {
      options: {
        autoload: true,
        autostart: true,
        permissions: false   
      },
      success: function() {},
      error: function() {}
    },

    modules: {},

    events: {},

    // Publish event to subscribers on a channel:topic
    // @param event [String] the event to publish in the form of
    //   channel:topic
    //
    // @example
    //   Bronson.publish('grid:change');
    //
    publish: function(event) {
      var _event_regex = /^[a-z]+((:[a-z]+){1})$/;
      var _event = event.toLowerCase();
      var _event_array = [];
      var _channel, _topic, _subscribers, _args;

      // Validate parameters
      if (!_event_regex.test(_event)) {
        throw new Error("Bronson.publish: event name must be in format subscriber of channel:topic");
      }

      // split event based on channel:event
      _event_array = _event.split(':');

      // extract channel and topic
      _channel = _event_array[0];
      _topic = _event_array[1];

      // Verify that the event exists
      if (!Bronson.events[_channel] || !Bronson.events[_channel][_topic]) return;

      // Get all the subscribers to this event
      _subscribers = Bronson.events[_channel][_topic].slice();

      // Get the arguments
      _args = [].slice.call(arguments, 1);

      for (var subscriber in _subscribers) {
        _subscribers[subscriber].callback.apply(this, _args);
      }
    },
    // Subscribe a module to an event
    //
    // @param event [String] the event string
    // @param callback [Function] the method to invoke 
    // @param context [Object] what 'this' is
    //
    // @example
    //   Bronson.subscribe('searchview:grid:change', function() {}, this);
    //
    subscribe: function(event, callback, context) {
      var _event_regex = /^[a-zA-Z0-9]+((:[a-zA-Z0-9]+){2})$/;
      var _event = event.toLowerCase();
      var _event_array, _subscriber, _channel, _topic;

      // validate paramaters
      if (!_event_regex.test(_event)) {
        throw new Error("Bronson.subscribe: event " + _event + " must be in format subscriber or subscriber:channel:topic");
      }
      if ((typeof callback !== "undefined" && callback !== null) && typeof callback !== "function") {
        throw new Error("Bronson.subscribe: callback must be a function");
      }

      // split event based on subscriber:channel:event
      _event_array = _event.split(':');

      // extract the subscriber, channel, topic from event
      _subscriber = _event_array[0];
      _channel = _event_array[1];
      _topic = _event_array[2];

      // verify that this subscription is permitted
      if (this.settings.permissions) {
        if (!Bronson.Permissions.validate(_subscriber, _channel))
          throw new Error("Bronson.subscribe: permissions do not allow this subscriber to listen to that channel");
      }

      // verify channel exists if not create it
      if (!this.events[_channel]) {
        this.events[_channel] = {};
      }

      // create the topic if it doesn't exist
      this.events[_channel][_topic] = (!this.events[_channel][_topic] ? [] : this.events[_channel][_topic]);

      // push the event
      this.events[_channel][_topic].push({
        subscriber: _subscriber,
        context: context || this,
        callback: callback
      });
    },
    // Unsubscribe events
    //
    // @param event [String] the event or subscriber to unsubscribe
    //
    // @example
    //   Bronson.unsubscribe('searchview');
    //
    unsubscribe: function(event) {
      var _event_regex = /^[a-zA-Z0-9]+((:[a-zA-Z0-9]+){2})?$/;
      var _event = event.toLowerCase();
      var _event_array = [];
      var _subscriber, _channel, _topic, i, topicObj;

      if (!_event_regex.test(_event)) {
        throw new Error("Bronson.unsubscribe: event must be in format subscriber or subscriber:channel:topic");
      }

      // split the event subscriber:channel:event
      _event_array = _event.split(':');

      // extract the subscriber, channel, topic
      _subscriber = _event_array[0];
      _channel = _event_array[1];
      _topic = _event_array[2];

      // if only subscriber passed we remove all events
      if (_event_array.length === 1) {
        for (_channel in this.events) {
          for (_topic in this.events[_channel]) {
            // enumerate topics in reverse order removing those that match
            for (i = this.events[_channel][_topic].length - 1; i >= 0; i--) {
              if (this.events[_channel][_topic][i].subscriber === _subscriber) {
                this.events[_channel][_topic].splice(i, 1);
              }
            }
          }
        }
      } else {
        // enumerate topics in reverse order removing those that match
        for (i = this.events[_channel][_topic].length - 1; i >= 0; i--) {
          topicObj = this.events[_channel][_topic][i];
          if (topicObj.subscriber === _subscriber) {
            this.events[_channel][_topic].splice(i, 1);
          }
        }
      }
    },
    // Load a module
    //
    // @param modules [Object or Array] the modules to load
    // 
    // @example
    //   Bronson.load({
    //     id: 'foo',
    //     path: 'path/to/foo',
    //     options: {
    //       autoload: true,
    //       autostart: false
    //     },
    //     success: function() {},
    //     error: function() {}
    //   });
    //
    load: function(modules) {
      // validate parameters
      if (!modules) {
        throw new Error("Bronson.load: must supply valid parameter modules");
      }

      if (!(modules instanceof Array))
        modules = [modules];

      // Iterate through all the modules to load
      for (var i = 0; i < modules.length; i++) {
        if (!modules[i].id)
          throw new Error("Bronson.load: must supply id parameter");
        if (!modules[i].path)
          throw new Error("Bronson.load: must supply path parameter");

        modules[i] = extend(extend({}, this.settings), modules[i]);
        amd_load(modules[i]);
      }
    },
    // Unload module by id
    //
    // @example
    //   Bronson.unload('TestModule')
    //
    unload: function(id) {
      if (!(typeof id !== "undefined" && id !== null) || typeof id !== "string") {
        throw new Error("Bronson.unload: id must be valid");
      }

      var module = this.find(id);
      var index = this.modules[module.type].indexOf(module);

      this.modules[module.type].splice(index, 1);

      if (this.modules[module.type].length === 0) {
        require.undef(module.type);
        delete this.modules[module.type];
      }

      contextMap = require.s.contexts._.defined;

      for (var key in contextMap) {
        if (contextMap.hasOwnProperty(key)) {
          require.undef(key);
        }
      }
    },
    // Unload all modues
    //
    // @example
    //   Bronson.unloadAll()
    //
    unloadAll: function() {
      var _modules = this.all();
      for (var i = 0; i < _modules.length; i++) {
        this.unload(_modules[i].id);
      }
    },
    // Start the module by id
    //
    // @example
    //  Bronson.start('foo');
    //
    start: function(id) {
      var _module = Bronson.find(id);
      if (!_module.started)
        _module.start();
    },
    // Start all the modules that aren't started
    //
    // @example
    //  Bronson.startAll();
    //
    startAll: function() {
      var _modules = this.findAll();
      for (var i = 0; i < _modules.length; i++) {
        if (!_modules[i].started)
          _modules[i].start();
      }
    },
    // Stop a module by id 
    //
    // @example
    //  Bronson.stop('foo');
    //
    stop: function(id) {
      var _module = Bronson.find(id);
      if (_module.started)
        _module.stop();
    },
    // Stop all started modules
    //
    // @example
    //  Bronson.stopAll();
    //
    stopAll: function() {
      var _modules = this.findAll();
      for (var i = 0; i < _modules.length; i++) {
        if (_modules[i].started)
          _modules[i].stop();
      }
    },
    // Find a module by instance id
    //
    // @example
    //  Bronson.find('foo');
    //
    find: function(id) {
      var _modules = this.modules;
      for (var module in _modules) {
        if (_modules.hasOwnProperty(module)) {
          for (var i in _modules[module]) {
            if (_modules[module][i].id === id)
              return _modules[module][i];
          }
        }
      }
    },
    // Find all and return all instantiated modules
    //
    // @example
    //  Bronson.findAll();
    //
    findAll: function() {
      var returnModules = [];
      var _modules = this.modules;
      for (var module in _modules) {
        if (_modules.hasOwnProperty(module)) {
          for (var i in _modules[module]) {
            returnModules.push(_modules[module][i]);
          }
        }
      }
      return returnModules;
    }
  });

  Bronson.Module = (function() {
    Module.prototype.id = "";

    Module.prototype.disposed = false;

    Module.prototype.started = false;

    function Module() {}

    Module.prototype.load = function(module) {
      this.id = module.id;
      this.path = module.path;
      this.onLoad(module.data);
    };

    Module.prototype.onLoad = function() {

    };

    Module.prototype.start = function() {
      this.started = true;
      this.onStart();
    };

    Module.prototype.onStart = function() {
    };

    Module.prototype.stop = function() {
      this.started = false;
      this.onStop();
    };

    Module.prototype.onStop = function() {
    };

    Module.prototype.unload = function() {
      if (this.disposed) {
        return;
      }
      this.disposed = true;
      this.onUnload();
      return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
    };

    Module.prototype.onUnload = function() {

    };

    return Module;
  })();

  Bronson.Permissions = {
    rules: {},

    set: function(props) {
      this.rules = extend(this.rules, props);
    },

    validate: function(subscriber, channel) {
      if (Bronson.settings.permissions) {
        if (this.rules[subscriber])
          if (this.rules[subscriber][channel])
            return true;
          else
            return false;
        else
          return false;
      }
    }
  };

  var amd_load = function(module) {
    try {
      // Load the module through RequireJS
      require(['module', module.path], function(Module, LoadedModule) {
        var _module = new LoadedModule();

        // Create the hash for storing of module instances if not already created
        Bronson.modules[module.path] = (!Bronson.modules[module.path] ? [] : Bronson.modules[module.path]);

        // Store them module instance
        Bronson.modules[module.path].push(_module);

        // Add the path to our Module
        extend(Module, { path: module.path});

        if (module.options.autoload) _module.load(module);
        if (module.options.autostart) _module.start();
        if (module.success) module.success(_module);
      });
    } catch (error) {
      if (module.error) {
        module.error(error);
      }
    }
  };

  var inherit = function(props) {
    var hasProp = {}.hasOwnProperty;
    var parent = this;
    var child;

    // Setup the constructor function for the new object
    if (props && hasProp.call(props, 'constructor')) {
      child = props.constructor;
    } else {
      child = function(){ return parent.apply(this, arguments); };
    }

    // Set the new objects prototype chain to inherit from parent
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;

    // Add prototype properties to the subclass if supplied
    if (props) {
      extend(child.prototype, props);
    }

    // Convience property for accessing the parent's prototype
    child.__super__ = parent.prototype;

    return child;
  };

  // Aliases
  Bronson.on      = Bronson.subscribe;
  Bronson.trigger = Bronson.publish;

  Bronson.Module.extend = inherit;

  return Bronson;
}));