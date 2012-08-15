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

      WeatherView.prototype.moduleId = null;

      WeatherView.prototype.tagName = 'li';

      WeatherView.prototype.className = 'module weather';

      WeatherView.prototype.started = true;

      WeatherView.prototype.events = function() {
        return {
          'click .close': 'dispose',
          'click .icon-stop': 'stop',
          'click .icon-play': 'start'
        };
      };

      WeatherView.prototype.initialize = function() {
        _.bindAll(this, 'render');
        return this.model.bind('change', this.render);
      };

      WeatherView.prototype.render = function() {
        $(this.el).html(_.template(WeatherTemplate, this.model.toJSON()));
        if (this.started) {
          $('.icon-play', this.el).removeClass('inactive');
          $('.icon-stop', this.el).addClass('inactive');
        } else {
          $('.icon-stop', this.el).removeClass('inactive');
          $('.icon-play', this.el).addClass('inactive');
        }
        return this;
      };

      WeatherView.prototype.stop = function() {
        Bronson.Api.stopModule(this.moduleId);
        $('.icon-stop', this.el).removeClass('inactive');
        $('.icon-play', this.el).addClass('inactive');
        return this.started = false;
      };

      WeatherView.prototype.start = function() {
        Bronson.Api.startModule(this.moduleId);
        $('.icon-play', this.el).removeClass('inactive');
        $('.icon-stop', this.el).addClass('inactive');
        return this.started = true;
      };

      WeatherView.prototype.dispose = function() {
        if (this.disposed) {
          return;
        }
        Bronson.Api.unloadModule(this.moduleId);
        this.disposed = true;
        this.model.unbind('change');
        this.model.dispose();
        return $(this.el).remove();
      };

      return WeatherView;

    })(Backbone.View);
  });

}).call(this);
