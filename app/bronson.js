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

  var extend = function(a, b) {
    for(var key in b)
      if(b.hasOwnProperty(key))
          a[key] = b[key];
    return a;
  };

  extend(Bronson, {
    version: '2.0.7',

    settings: {
      autoload: true,
      autostart: true,
      permissions: false,
      success: function() {},
      error: function() {}
    },

    modules: {},

    events: {},

    // Publish an event to it's subscribers
    // @param event [String] the event the publish in the form of
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
      var _event_regex = /^[a-z]+((:[a-z]+){2})$/;
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
      var _event_regex = /^[a-z]+((:[a-z]+){2})?$/;
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
            for (i = 0; i < this.events[_channel][_topic].length; i++) {
              if (this.events[_channel][_topic][i].subscriber === _subscriber) {
                this.events[_channel][_topic].splice(i, 1);
                break;
              }
            }
          }
        }
      } else {
        for (i = 0; i < this.events[_channel][_topic].length; i++) {
          topicObj = this.events[_channel][_topic][i];
          if (topicObj.subscriber === _subscriber) {
            this.events[_channel][_topic].splice(i, 1);
            return;
          }
        }
      }
    },
    // Load a module
    //
    // @param module [String] the AMD module to load(alias or relative path)
    // @param config [Object] whether or not to autostart the module
    // @param callback [Function] (optional) the callback to invoke upon module load
    // @param autostart [Boolean] (optional) whether or not to start the module on load
    //
    // @example
    //   Bronson.load 'example', { el: '//test' }, ->
    //     console.log 'loaded!'
    //   , true
    //
    load: function(modules) {
      // validate parameters
      if (!modules) {
        throw new Error("Bronson.load: must supply valid parameter modules");
      }

      // Iterate through all the modules to load
      for (var i = 0; i < modules.length; i++) {
        try {
          var _moduleName, _settings;

          // Load by object or string
          if (typeof modules[i] == 'object') {
            _moduleName = Object.getOwnPropertyNames(modules[i])[0];
          
            // extend default settings with passed in module settings returning cloned object
            _settings = extend({}, extend(this.settings, modules[i][_moduleName]));

          } else if (typeof modules[i] == 'string') {
            _moduleName = modules[i];
            _settings = this.settings;
          } else {
            throw new Error("Bronson.load: Please supply a valid object or string to load");
          }

          // Load the module through RequireJS
          require(['module', _moduleName], function(Module, LoadedModule) {
            var loadedModule = new LoadedModule();
            var _module = new LoadedModule(_settings.data);

            // Create the hash for storing of module instances if not already created
            Bronson.modules[_moduleName] = (!Bronson.modules[_moduleName] ? [] : Bronson.modules[_moduleName]);

            // Store them module instance
            Bronson.modules[_moduleName].push(_module);

            // Add the path to our Module
            extend(Module, { path: _moduleName});

            if (_settings.autoload) _module.load(Module);
            if (_settings.autostart) _module.start();
            if (_settings.success) _settings.success(_module);
          });
        } catch (error) {
          if (_settings.error) {
            _settings.error(error);
          }
        }
      }
    },
    // Unload module
    //
    // @example
    //   Bronson.unload 'TestModule'
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
    //  Bronson.start('_@r6');
    //
    start: function() {
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
    //  Bronson.stop('_@r6');
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
    //  Bronson.find('_@r6');
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
      this.onLoad();
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