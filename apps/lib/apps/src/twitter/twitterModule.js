(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'apps/lib/twitter/views/tweetsView', 'apps/lib/twitter/collection/tweetsCollection'], function($, _, Backbone, Bronson, TweetsView, TweetsCollection) {
    var TwitterModule;
    return TwitterModule = (function(_super) {

      __extends(TwitterModule, _super);

      function TwitterModule(parameters) {
        if (parameters == null) {
          parameters = {};
        }
        this.el = parameters.el;
        TwitterModule.__super__.constructor.apply(this, arguments);
      }

      TwitterModule.prototype.load = function() {
        var tweetView, tweetsCollection,
          _this = this;
        tweetsCollection = new TweetsCollection();
        tweetView = new TweetsView({
          collection: tweetsCollection
        });
        tweetsCollection.fetch({
          data: {
            geocode: "35.689488,139.691706,1mi",
            rpp: 4
          },
          silent: true,
          success: function() {
            return $(_this.el).append(tweetView.render().el);
          }
        });
        return Bronson.Core.subscribe('TwitterModule', 'geoUpdate', function(data) {
          return tweetsCollection.fetch({
            data: {
              geocode: "" + data.latitude + "," + data.longitude + ",1mi"
            }
          });
        });
      };

      TwitterModule.prototype.start = function() {};

      TwitterModule.prototype.stop = function() {};

      TwitterModule.prototype.unload = function() {};

      return TwitterModule;

    })(Bronson.Module);
  });

}).call(this);
