(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'text!apps/src/maps/templates/mapTemplate.html'], function($, _, Backbone, Bronson, MapTemplate) {
    var MapView;
    return MapView = (function(_super) {

      __extends(MapView, _super);

      function MapView() {
        return MapView.__super__.constructor.apply(this, arguments);
      }

      MapView.prototype.moduleId = null;

      MapView.prototype.tagName = 'li';

      MapView.prototype.className = 'module maps';

      MapView.prototype.started = true;

      MapView.prototype.initialize = function() {};

      MapView.prototype.events = function() {
        return {
          'click .close': 'dispose',
          'click .icon-stop': 'stop',
          'click .icon-play': 'start'
        };
      };

      MapView.prototype.render = function() {
        var _this = this;
        Bronson.subscribe('maps:app:addmarker', function(data) {
          var latlng, marker;
          latlng = new google.maps.LatLng(data.latitude, data.longitude);
          marker = new google.maps.Marker({
            animation: google.maps.Animation.DROP,
            position: latlng,
            map: _this.map
          });
          return _this.map.panTo(latlng);
        });
        $(this.el).prepend(_.template(MapTemplate, null));
        if (this.started) {
          $('.icon-play', this.el).removeClass('inactive');
          $('.icon-stop', this.el).addClass('inactive');
        } else {
          $('.icon-stop', this.el).removeClass('inactive');
          $('.icon-play', this.el).addClass('inactive');
        }
        return this;
      };

      MapView.prototype.stop = function() {
        console.log(this.moduleId);
        Bronson.stop(this.moduleId);
        $('.icon-stop', this.el).removeClass('inactive');
        $('.icon-play', this.el).addClass('inactive');
        return this.started = false;
      };

      MapView.prototype.start = function() {
        Bronson.start(this.moduleId);
        $('.icon-play', this.el).removeClass('inactive');
        $('.icon-stop', this.el).addClass('inactive');
        return this.started = true;
      };

      MapView.prototype.dispose = function() {
        Bronson.unload(this.moduleId);
        return $(this.el).remove();
      };

      return MapView;

    })(Backbone.View);
  });

}).call(this);
