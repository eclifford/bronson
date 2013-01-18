(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'text!apps/src/instagram/templates/carouselItemTemplate.html'], function($, _, Backbone, Bronson, CarouselItemTemplate) {
    var CarouselItemView;
    return CarouselItemView = (function(_super) {

      __extends(CarouselItemView, _super);

      function CarouselItemView() {
        return CarouselItemView.__super__.constructor.apply(this, arguments);
      }

      CarouselItemView.prototype.className = 'item';

      CarouselItemView.prototype.events = {
        "click": 'notify'
      };

      CarouselItemView.prototype.initialize = function() {};

      CarouselItemView.prototype.notify = function() {
        var coords;
        coords = {
          latitude: this.model.get('location').latitude,
          longitude: this.model.get('location').longitude
        };
        return Bronson.publish('app:addmarker', coords);
      };

      CarouselItemView.prototype.render = function() {
        $(this.el).html(_.template(CarouselItemTemplate, this.model.toJSON()));
        return this;
      };

      return CarouselItemView;

    })(Backbone.View);
  });

}).call(this);
