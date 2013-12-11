(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'tpl!modules/foursquare/templates/venuesItemTemplate.html'], function(Marionette, VenuesItemTemplate) {
    var VenuesItemView, _ref;
    return VenuesItemView = (function(_super) {
      __extends(VenuesItemView, _super);

      function VenuesItemView() {
        _ref = VenuesItemView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      VenuesItemView.prototype.template = VenuesItemTemplate;

      VenuesItemView.prototype.events = {
        'click': 'selectVenue'
      };

      VenuesItemView.prototype.selectVenue = function() {
        var coords;
        coords = {
          title: this.model.get('name'),
          lat: this.model.get('location').lat,
          lng: this.model.get('location').lng
        };
        return Bronson.publish('app:addmarker', coords);
      };

      return VenuesItemView;

    })(Marionette.ItemView);
  });

}).call(this);
