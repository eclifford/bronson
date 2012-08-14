(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'apps/lib/foursquare/collection/venuesCollection', 'apps/lib/foursquare/views/venuesView'], function($, _, Backbone, Bronson, VenuesCollection, VenuesView) {
    var FoursquareModule;
    return FoursquareModule = (function(_super) {

      __extends(FoursquareModule, _super);

      function FoursquareModule(parameters) {
        if (parameters == null) {
          parameters = {};
        }
        this.el = parameters.el;
        FoursquareModule.__super__.constructor.apply(this, arguments);
      }

      FoursquareModule.prototype.load = function() {
        var _this = this;
        this.venuesCollection = new VenuesCollection();
        this.venuesView = new VenuesView({
          collection: this.venuesCollection
        });
        return this.venuesCollection.fetch({
          data: {
            ll: '35.689488, 139.691706',
            oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y',
            v: '20120805',
            limit: 5,
            section: 'food'
          },
          silent: true,
          success: function() {
            return $(_this.el).append(_this.venuesView.render().el);
          }
        });
      };

      FoursquareModule.prototype.start = function() {
        var _this = this;
        Bronson.Api.subscribe('foursquaremodule', 'geoUpdate', function(data) {
          return _this.venuesCollection.fetch({
            data: {
              ll: "" + data.latitude + "," + data.longitude,
              oauth_token: 'O4KTMAIQA3K40AYAU522GP0ILLUY2SVSIH54WSAAGNCOCM1Y',
              v: '20120805',
              limit: 5,
              section: 'food'
            }
          });
        });
        return FoursquareModule.__super__.start.call(this);
      };

      FoursquareModule.prototype.stop = function() {
        Bronson.Api.unsubscribe('foursquaremodule', 'geoUpdate');
        return FoursquareModule.__super__.stop.call(this);
      };

      FoursquareModule.prototype.unload = function() {
        return FoursquareModule.__super__.unload.call(this);
      };

      return FoursquareModule;

    })(Bronson.Module);
  });

}).call(this);
