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

      VenuesView.prototype.tagName = 'li';

      VenuesView.prototype.className = 'module foursquare';

      VenuesView.prototype.events = function() {
        return {
          'click .close': 'dispose'
        };
      };

      VenuesView.prototype.initialize = function() {
        var _this = this;
        this.id = Math.random().toString(36).substring(7);
        _.bindAll(this, 'render');
        this.collection.bind('reset', this.render);
        return Bronson.Core.subscribe('FoursquareModule', 'message', function(msg) {
          return $(_this.el).prepend("<div class='alert alert-success'>HEY FUCKER</div>");
        });
      };

      VenuesView.prototype.render = function() {
        $(this.el).html(_.template(VenuesTemplate, {
          id: this.id
        }));
        _.each(this.collection.models, (function(item) {
          return this.renderItem(item);
        }), this);
        return this;
      };

      VenuesView.prototype.renderItem = function(item) {
        var venueItemView;
        venueItemView = new VenueItemView({
          model: item
        });
        return $(this.el).append(venueItemView.render().el);
      };

      VenuesView.prototype.dispose = function() {
        this.collection.unbind('change');
        this.collection.dispose();
        return $(this.el).remove();
      };

      return VenuesView;

    })(Backbone.View);
  });

}).call(this);
