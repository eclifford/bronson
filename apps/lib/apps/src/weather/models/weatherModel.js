(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone'], function(_, Backbone) {
    var WeatherModel;
    return WeatherModel = (function(_super) {

      __extends(WeatherModel, _super);

      function WeatherModel() {
        return WeatherModel.__super__.constructor.apply(this, arguments);
      }

      WeatherModel.prototype.dispose = function() {
        this.off();
        return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
      };

      return WeatherModel;

    })(Backbone.Model);
  });

}).call(this);
