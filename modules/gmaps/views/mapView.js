(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'tpl!modules/gmaps/templates/mapTemplate.tmpl'], function(Marionette, MapTemplate) {
    var MapView, _ref;
    return MapView = (function(_super) {
      __extends(MapView, _super);

      function MapView() {
        _ref = MapView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      MapView.prototype.template = MapTemplate;

      MapView.prototype.className = 'module';

      MapView.prototype.events = function() {
        return {
          'click .glyphicon-remove': 'dispose',
          'click .glyphicon-stop': 'stop',
          'click .glyphicon-play': 'start'
        };
      };

      MapView.prototype.stop = function() {
        Bronson.stop(this.moduleId);
        $('.glyphicon-stop', this.el).addClass('active');
        $('.glyphicon-play', this.el).removeClass('active');
        return this.started = false;
      };

      MapView.prototype.start = function() {
        Bronson.start(this.moduleId);
        $('.glyphicon-stop', this.el).removeClass('active');
        $('.glyphicon-play', this.el).addClass('active');
        return this.started = true;
      };

      MapView.prototype.dispose = function() {
        return this.close();
      };

      return MapView;

    })(Marionette.CompositeView);
  });

}).call(this);
