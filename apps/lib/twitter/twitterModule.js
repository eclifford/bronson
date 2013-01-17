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
      }

      TwitterModule.prototype.load = function() {
        var tweetView,
          _this = this;
        this.tweetsCollection = new TweetsCollection();
        tweetView = new TweetsView({
          collection: this.tweetsCollection
        });
        tweetView.moduleId = this.id;
        return this.tweetsCollection.fetch({
          data: {
            geocode: "35.689488,139.691706,1mi",
            rpp: 4
          },
          silent: true,
          success: function() {
            return $(_this.el).append(tweetView.render().el);
          }
        });
      };

      TwitterModule.prototype.start = function() {
        var _this = this;
        Bronson.subscribe('twitter:app:geoupdate', function(data) {
          return _this.tweetsCollection.fetch({
            data: {
              geocode: "" + data.latitude + "," + data.longitude + ",1mi"
            }
          });
        });
        return TwitterModule.__super__.start.call(this);
      };

      TwitterModule.prototype.stop = function() {
        Bronson.unsubscribe('twitter');
        return TwitterModule.__super__.stop.call(this);
      };

      TwitterModule.prototype.unload = function() {
        return TwitterModule.__super__.unload.call(this);
      };

      return TwitterModule;

    })(Bronson.Module);
  });

}).call(this);
