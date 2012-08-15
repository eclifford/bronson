(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'apps/lib/twitter/views/tweetItemView', 'text!apps/src/twitter/templates/tweetsTemplate.html'], function($, _, Backbone, Bronson, TweetItemView, TweetsTemplate) {
    var TweetsView;
    return TweetsView = (function(_super) {

      __extends(TweetsView, _super);

      function TweetsView() {
        return TweetsView.__super__.constructor.apply(this, arguments);
      }

      TweetsView.prototype.moduleId = null;

      TweetsView.prototype.tagName = 'li';

      TweetsView.prototype.className = 'module twitter';

      TweetsView.prototype.started = true;

      TweetsView.prototype.events = function() {
        return {
          'click .close': 'dispose',
          'click .icon-stop': 'stop',
          'click .icon-play': 'start'
        };
      };

      TweetsView.prototype.initialize = function() {
        _.bindAll(this, 'render');
        return this.collection.bind('reset', this.render);
      };

      TweetsView.prototype.render = function() {
        $(this.el).html(_.template(TweetsTemplate));
        _.each(this.collection.models, (function(item) {
          return this.renderItem(item);
        }), this);
        if (this.started) {
          $('.icon-play', this.el).removeClass('inactive');
          $('.icon-stop', this.el).addClass('inactive');
        } else {
          $('.icon-stop', this.el).removeClass('inactive');
          $('.icon-play', this.el).addClass('inactive');
        }
        return this;
      };

      TweetsView.prototype.stop = function() {
        Bronson.Api.stopModule(this.moduleId);
        $('.icon-stop', this.el).removeClass('inactive');
        $('.icon-play', this.el).addClass('inactive');
        return this.started = false;
      };

      TweetsView.prototype.start = function() {
        Bronson.Api.startModule(this.moduleId);
        $('.icon-play', this.el).removeClass('inactive');
        $('.icon-stop', this.el).addClass('inactive');
        return this.started = true;
      };

      TweetsView.prototype.renderItem = function(item) {
        var tweetItemView;
        tweetItemView = new TweetItemView({
          model: item
        });
        return $(this.el).append(tweetItemView.render().el);
      };

      TweetsView.prototype.dispose = function() {
        Bronson.Api.unloadModule(this.moduleId);
        this.collection.unbind('change');
        this.collection.dispose();
        return $(this.el).remove();
      };

      return TweetsView;

    })(Backbone.View);
  });

}).call(this);
