/*!
 * Bronsonjs - AMD module framework
 * (c) 2012-2014 Eric Clifford <ericgclifford@gmail.com>
 * MIT Licensed.
 *
 * http://bronsonjs.com
 * http://github.com/eclifford/bronson
 */
(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define([], function() {
      return (root.Bronson = factory(root));
    });
  } else if (typeof exports !== 'undefined') {
    module.exports = factory(root);
  } else {
    root.Bronson = factory(root);
  }
}(this, function(root) {
  'use strict';

  var Bronson =  {
    version: '2.0.17',

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
      var event_regex = /^[a-z]+((:[a-z]+){1})$/;
      var subscribers, event_array = [];
      var channel, topic, args;

      // make event lowercase
      event = event.toLowerCase();

      // Validate parameters
      if (!event_regex.test(event)) {
        throw new Error("Bronson.publish: event name must be in format subscriber of channel:topic");
      }

      // extract channel and topic
      event_array = event.split(':');
      channel = event_array[0];
      topic = event_array[1];

      // Verify that the event exists
      if (!Bronson.events[channel] || !Bronson.events[channel][topic]) {
        return;
      }

      // Get all the subscribers to this event
      subscribers = Bronson.events[channel][topic].slice();

      // Get the arguments
      args = [].slice.call(arguments, 1);

      // publish specified event to each subscriber
      for (var i = 0; i < subscribers.length; i++) {
        subscribers[i].callback.apply(subscribers[i].context, args);
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
      var event_regex = /^[a-zA-Z0-9]+((:[a-zA-Z0-9]+){2})$/;
      var event_array = [];
      var subscriber, channel, topic;

      // make event lowercase
      event = event.toLowerCase();

      // validate paramaters
      if (!event_regex.test(event)) {
        throw new Error("Bronson.subscribe: event " + event + " must be in format subscriber or subscriber:channel:topic");
      }
      if ((typeof callback !== "undefined" && callback !== null) && typeof callback !== "function") {
        throw new Error("Bronson.subscribe: callback must supplied and must be a function");
      }

      // extract the subscriber, channel, topic from event
      event_array = event.split(':');
      subscriber = event_array[0];
      channel = event_array[1];
      topic = event_array[2];

      // verify that this subscription is permitted
      if (this.settings.permissions) {
        if (!Bronson.Permissions.validate(subscriber, channel))
          throw new Error("Bronson.subscribe: permissions do not allow this subscriber to listen to that channel");
      }

      // verify channel exists if not create it
      if (!this.events[channel]) {
        this.events[channel] = {};
      }

      // create the topic if it doesn't exist
      this.events[channel][topic] = (!this.events[channel][topic] ? [] : this.events[channel][topic]);

      // push the event
      this.events[channel][topic].push({
        subscriber: subscriber,
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
      var event_regex = /^[a-zA-Z0-9]+((:[a-zA-Z0-9]+){2})?$/;
      var event_array = [];
      var subscriber, channel, topic, i, topicObj;

      // make event lowercase
      event = event.toLowerCase();

      if (!event_regex.test(event)) {
        throw new Error("Bronson.unsubscribe: event must be in format subscriber or subscriber:channel:topic");
      }

      // extract the subscriber, channel, topic
      event_array = event.split(':');
      subscriber = event_array[0];
      channel = event_array[1];
      topic = event_array[2];

      // if only subscriber passed we remove all events
      if (event_array.length === 1) {
        for (channel in this.events) {
          for (topic in this.events[channel]) {
            // enumerate topics in reverse order removing those that match
            for (i = this.events[channel][topic].length - 1; i >= 0; i--) {
              if (this.events[channel][topic][i].subscriber === subscriber) {
                this.events[channel][topic].splice(i, 1);
              }
            }
          }
        }
      } else {
        // enumerate topics in reverse order removing those that match
        for (i = this.events[channel][topic].length - 1; i >= 0; i--) {
          topicObj = this.events[channel][topic][i];
          if (topicObj.subscriber === subscriber) {
            this.events[channel][topic].splice(i, 1);
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
    load: function(data) {
      var module;

      // validate parameters
      if (!data) {
        throw new Error("Bronson.load: must supply valid parameter data");
      }

      if (!(data instanceof Array)) {
        data = [data];
      }

      // Iterate through all the data to load
      for (var i = 0; i < data.length; i++) {
        if (!data[i].id) {
          throw new Error("Bronson.load: must supply id parameter");
        }
        if (!data[i].path) {
          throw new Error("Bronson.load: must supply path parameter");
        }

        // merge incoming data object with default settings
        module = Bronson.Utils.merge({}, this.settings, data[i]);

        // load with require
        this._require(module);
      }
    },
    // Load a module with Require.JS
    //
    // @param module [Object] the module to load
    //
    _require: function(data) {
      // Load the module through RequireJS
      require(['module', data.path], function(Module, LoadedModule) {
        var module = new LoadedModule();

        // Create the hash for storing of data instances if not already created
        Bronson.modules[data.path] = (!Bronson.modules[data.path] ? [] : Bronson.modules[data.path]);

        // Store them data instance
        Bronson.modules[data.path].push(module);

        // Add the path to our Module
        Bronson.Utils.merge(Module, { path: data.path});

        if (data.options.autoload) module.load(data);
        if (data.options.autostart) module.start();
        if (data.success) data.success(module);

      }, function(err) {
        var failedId = err.requireModules && err.requireModules[0];
        requirejs.undef(failedId);

        throw new Error("Bronson._require: error loading with RequireJS", err);
      });
    },
    // Unload module by id
    //
    // @example
    //   Bronson.unload('TestModule')
    //
    unload: function(id) {
      var module, index;

      if (!(typeof id !== "undefined" && id !== null) || typeof id !== "string") {
        throw new Error("Bronson.unload: id must be valid");
      }

      module = this.find(id);

      if (!module) {
        throw new Error("Bronson.unload: attempted to unload module module that does not exist", id);
      }

      index = this.modules[module.type].indexOf(module);

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
      var modules = this.all();
      for (var i = 0; i < modules.length; i++) {
        this.unload(modules[i].id);
      }
    },
    // Start the module by id
    //
    // @example
    //  Bronson.start('foo');
    //
    start: function(id) {
      var module = this.find(id);
      if (!module.started) {
        module.start();
      }
    },
    // Start all the modules that aren't started
    //
    // @example
    //  Bronson.startAll();
    //
    startAll: function() {
      var modules = this.findAll();
      for (var i = 0; i < modules.length; i++) {
        if (!modules[i].started) {
          modules[i].start();
        }
      }
    },
    // Stop a module by id
    //
    // @example
    //  Bronson.stop('foo');
    //
    stop: function(id) {
      var module = this.find(id);
      if (module.started) {
        module.stop();
      }
    },
    // Stop all started modules
    //
    // @example
    //  Bronson.stopAll();
    //
    stopAll: function() {
      var modules = this.findAll();
      for (var i = 0; i < modules.length; i++) {
        if (modules[i].started) {
          modules[i].stop();
        }
      }
    },
    // Find a module by instance id
    //
    // @example
    //  Bronson.find('foo');
    //
    find: function(id) {
      for (var module in this.modules) {
        if (this.modules.hasOwnProperty(module)) {
          for (var i in this.modules[module]) {
            if (this.modules[module][i].id === id) {
              return this.modules[module][i];
            }
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
      var modules = this.modules;
      for (var module in modules) {
        if (modules.hasOwnProperty(module)) {
          for (var i in modules[module]) {
            returnModules.push(modules[module][i]);
          }
        }
      }
      return returnModules;
    }
  };

  Bronson.Module = (function() {
    Module.prototype.id = "";

    Module.prototype.disposed = false;

    Module.prototype.started = false;

    function Module() {}

    Module.prototype.load = function(module) {
      this.id = module.id;
      this.path = module.path;
      this.loaded = true;

      // bind subscription events
      if(this.events) {
        for (var event in this.events) {
          Bronson.subscribe(module.id + ':' + event, this[this.events[event]], this);
        }
      }

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
      this.rules = Bronson.Utils.merge({}, this.rules, props);
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

  Bronson.Utils = {
    // http://github.com/eclifford/n-deep-merge
    merge: function (dest) {
      for (var i = 1; i < arguments.length; i++) {
        var source = arguments[i];

        if (!source && typeof source !== 'boolean')
          continue;

        var isObj = typeof source === 'object',
            isArray = Object.prototype.toString.call(source) == '[object Array]';

        if(isArray) {
          dest = dest || [];
          for (var x = 0; x < source.length; x++) {
            if (dest.indexOf(source[x]) === -1) {
              dest.push(source[x]);
            }
          }
        } else if (isObj) {
          dest = dest || {};
          for (var key in source) {
            dest[key] = this.merge(dest[key], source[key]);
          }
        } else {
          dest = source;
        }
      }
      return dest;
    },
    inherit: function(props) {
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
      function Obj() { this.constructor = child; }
      Obj.prototype = parent.prototype;
      child.prototype = new Obj();

      // Add prototype properties to the subclass if supplied
      if (props) {
        Bronson.Utils.merge(child.prototype, props);
      }

      // Convience property for accessing the parent's prototype
      child.__super__ = parent.prototype;

      return child;
    }
  };

  // Aliases
  Bronson.on      = Bronson.subscribe;
  Bronson.trigger = Bronson.publish;

  Bronson.Module.extend = Bronson.Utils.inherit;

  return Bronson;
}));
