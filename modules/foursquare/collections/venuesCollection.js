(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var VenuesCollection, _ref;
    return VenuesCollection = (function(_super) {
      __extends(VenuesCollection, _super);

      function VenuesCollection() {
        _ref = VenuesCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      VenuesCollection.prototype.url = "https://api.foursquare.com/v2/venues/search";

      VenuesCollection.prototype.parse = function(response) {
        return response.response.venues;
      };

      return VenuesCollection;

    })(Backbone.Collection);
  });

}).call(this);
