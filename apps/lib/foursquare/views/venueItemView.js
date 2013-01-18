(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'text!apps/src/foursquare/templates/venueTemplate.html'], function($, _, Backbone, Bronson, VenueItemTemplate) {
    var VenueItemView;
    return VenueItemView = (function(_super) {

      __extends(VenueItemView, _super);

      function VenueItemView() {
        return VenueItemView.__super__.constructor.apply(this, arguments);
      }

      VenueItemView.prototype.events = {
        "click": 'notify'
      };

      VenueItemView.prototype.initialize = function() {};

      VenueItemView.prototype.notify = function() {
        var coords;
        coords = {
          title: this.model.get('name'),
          latitude: this.model.get('location').lat,
          longitude: this.model.get('location').lng
        };
        return Bronson.publish('app:addmarker', coords);
      };

      VenueItemView.prototype.render = function() {
        $(this.el).html(_.template(VenueItemTemplate, this.model.toJSON()));
        return this;
      };

      return VenueItemView;

    })(Backbone.View);
  });

}).call(this);
