(function() {
  var Permissions;

  Permissions = R8.Permissions = {
    _enabled: false,
    enabled: function(value) {
      return this._enabled = !!value;
    },
    rules: {},
    extend: function(props) {
      var rules;
      return rules = $.extend(true, {}, props, this);
    },
    validate: function(subscriber, channel) {
      var test, _ref;
      if (this._enabled) {
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

}).call(this);
