(function() {
  var __hasProp = Object.prototype.hasOwnProperty;

  R8.Module = (function() {

    Module.prototype.view = null;

    Module.prototype.currentId = null;

    Module.prototype.disposed = false;

    function Module() {
      this.initialize.apply(this, arguments);
    }

    Module.prototype.initialize = function() {};

    Module.prototype.dispose = function() {
      var obj, prop, properties, _i, _len;
      if (this.disposed) return;
      for (prop in this) {
        if (!__hasProp.call(this, prop)) continue;
        obj = this[prop];
        if (obj && typeof obj.dispose === 'function') {
          obj.dispose();
          delete this[prop];
        }
      }
      properties = ['currentId'];
      for (_i = 0, _len = properties.length; _i < _len; _i++) {
        prop = properties[_i];
        delete this[prop];
      }
      this.disposed = true;
      return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
    };

    return Module;

  })();

}).call(this);
