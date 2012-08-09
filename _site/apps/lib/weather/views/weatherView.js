(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'text!apps/src/weather/templates/weatherTemplate.html'], function($, _, Backbone, Bronson, WeatherTemplate) {
    var WeatherView;
    return WeatherView = (function(_super) {

      __extends(WeatherView, _super);

      function WeatherView() {
        return WeatherView.__super__.constructor.apply(this, arguments);
      }

      WeatherView.prototype.tagName = 'li';

      WeatherView.prototype.className = 'module weather';

      WeatherView.prototype.events = function() {
        return {
          'click .close': 'dispose'
        };
      };

      WeatherView.prototype.initialize = function() {
        this.id = Math.random().toString(36).substring(7);
        _.bindAll(this, 'render');
        return this.model.bind('change', this.render);
      };

      WeatherView.prototype.render = function() {
        $(this.el).html(_.template(WeatherTemplate, this.model.toJSON()));
        return this;
      };

      WeatherView.prototype.dispose = function() {
        console.log('dispose');
        if (this.disposed) {
          return;
        }
        this.disposed = true;
        this.model.unbind('change');
        this.model.dispose();
        return $(this.el).remove();
      };

      return WeatherView;

    })(Backbone.View);
  });

}).call(this);
