(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'tpl!modules/carousel/templates/carouselItemTemplate.tmpl'], function(Marionette, CarouselItemTemplate) {
    var CarouselItemView, _ref;
    return CarouselItemView = (function(_super) {
      __extends(CarouselItemView, _super);

      function CarouselItemView() {
        _ref = CarouselItemView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CarouselItemView.prototype.className = 'item text-center';

      CarouselItemView.prototype.template = CarouselItemTemplate;

      CarouselItemView.prototype.events = {
        'click': 'selectImage'
      };

      CarouselItemView.prototype.selectImage = function() {
        var coords;
        coords = {
          lat: this.model.get('location').latitude,
          lng: this.model.get('location').longitude
        };
        return Bronson.publish('app:addmarker', coords);
      };

      return CarouselItemView;

    })(Marionette.ItemView);
  });

}).call(this);
