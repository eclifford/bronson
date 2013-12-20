(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'modules/carousel/views/carouselItemView', 'tpl!modules/carousel/templates/carouselTemplate.tmpl', 'bootstrap/carousel'], function(Marionette, CarouselItemView, CarouselTemplate) {
    var CarouselView, _ref;
    return CarouselView = (function(_super) {
      __extends(CarouselView, _super);

      function CarouselView() {
        _ref = CarouselView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CarouselView.prototype.itemView = CarouselItemView;

      CarouselView.prototype.className = 'module';

      CarouselView.prototype.itemViewContainer = '.carousel-inner';

      CarouselView.prototype.template = CarouselTemplate;

      CarouselView.prototype.events = function() {
        return {
          'click .glyphicon-remove': 'dispose',
          'click .glyphicon-stop': 'stop',
          'click .glyphicon-play': 'start'
        };
      };

      CarouselView.prototype.initialize = function() {
        return this.templateHelpers = {
          cid: this.cid
        };
      };

      CarouselView.prototype.onRender = function() {
        return this.$el.carousel().carousel('next');
      };

      CarouselView.prototype.stop = function() {
        Bronson.stop(this.moduleId);
        $('.glyphicon-stop', this.el).addClass('active');
        $('.glyphicon-play', this.el).removeClass('active');
        return this.started = false;
      };

      CarouselView.prototype.start = function() {
        Bronson.start(this.moduleId);
        $('.glyphicon-stop', this.el).removeClass('active');
        $('.glyphicon-play', this.el).addClass('active');
        return this.started = true;
      };

      CarouselView.prototype.dispose = function() {
        return this.close();
      };

      return CarouselView;

    })(Marionette.CompositeView);
  });

}).call(this);
