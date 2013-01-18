(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'apps/lib/foursquare/views/venueItemView', 'text!apps/src/foursquare/templates/venuesTemplate.html'], function($, _, Backbone, Bronson, VenueItemView, VenuesTemplate) {
    var VenuesView;
    return VenuesView = (function(_super) {

      __extends(VenuesView, _super);

      function VenuesView() {
        return VenuesView.__super__.constructor.apply(this, arguments);
      }

      VenuesView.prototype.moduleId = null;

      VenuesView.prototype.tagName = 'li';

      VenuesView.prototype.className = 'module foursquare';

      VenuesView.prototype.started = true;

      VenuesView.prototype.events = function() {
        return {
          'click .close': 'dispose',
          'click .icon-stop': 'stop',
          'click .icon-play': 'start'
        };
      };

      VenuesView.prototype.initialize = function() {
        _.bindAll(this, 'render');
        return this.collection.bind('reset', this.render);
      };

      VenuesView.prototype.render = function() {
        $(this.el).html(_.template(VenuesTemplate, null));
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

      VenuesView.prototype.renderItem = function(item) {
        var venueItemView;
        venueItemView = new VenueItemView({
          model: item
        });
        return $(this.el).append(venueItemView.render().el);
      };

      VenuesView.prototype.stop = function() {
        Bronson.stop(this.moduleId);
        $('.icon-stop', this.el).removeClass('inactive');
        $('.icon-play', this.el).addClass('inactive');
        return this.started = false;
      };

      VenuesView.prototype.start = function() {
        Bronson.start(this.moduleId);
        $('.icon-play', this.el).removeClass('inactive');
        $('.icon-stop', this.el).addClass('inactive');
        return this.started = true;
      };

      VenuesView.prototype.dispose = function() {
        Bronson.unload(this.moduleId);
        this.collection.unbind('change');
        this.collection.dispose();
        return $(this.el).remove();
      };

      return VenuesView;

    })(Backbone.View);
  });

}).call(this);
