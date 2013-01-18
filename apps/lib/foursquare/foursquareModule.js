(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'apps/lib/foursquare/collection/venuesCollection', 'apps/lib/foursquare/views/venuesView'], function($, _, Backbone, Bronson, VenuesCollection, VenuesView) {
    var FoursquareModule;
    return FoursquareModule = (function(_super) {

      __extends(FoursquareModule, _super);

      function FoursquareModule(config) {
        if (config == null) {
          config = {};
        }
        this.el = config.el;
      }

      FoursquareModule.prototype.load = function() {
        var _this = this;
        this.venuesCollection = new VenuesCollection();
        this.venuesView = new VenuesView({
          collection: this.venuesCollection
        });
        this.venuesView.moduleId = this.id;
        return this.venuesCollection.fetch({
          data: {
            ll: '37.788086, -122.401111',
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
        Bronson.subscribe('foursqaure:app:geoupdate', function(data) {
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
        Bronson.unsubscribe('foursqaure');
        return FoursquareModule.__super__.stop.call(this);
      };

      FoursquareModule.prototype.unload = function() {
        return FoursquareModule.__super__.unload.call(this);
      };

      return FoursquareModule;

    })(Bronson.Module);
  });

}).call(this);
