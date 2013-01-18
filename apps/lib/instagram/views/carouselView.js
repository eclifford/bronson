(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'bronson', 'apps/lib/instagram/views/carouselItemView', 'text!apps/src/instagram/templates/carouselTemplate.html'], function($, _, Backbone, Bronson, CarouselItemView, CarouselTemplate) {
    var CarouselView;
    return CarouselView = (function(_super) {

      __extends(CarouselView, _super);

      function CarouselView() {
        return CarouselView.__super__.constructor.apply(this, arguments);
      }

      CarouselView.prototype.moduleId = null;

      CarouselView.prototype.tagName = 'li';

      CarouselView.prototype.className = 'module instagram';

      CarouselView.prototype.started = true;

      CarouselView.prototype.events = function() {
        return {
          'click .close': 'dispose',
          'click .icon-stop': 'stop',
          'click .icon-play': 'start'
        };
      };

      CarouselView.prototype.initialize = function() {
        _.bindAll(this, 'render', 'dispose');
        return this.collection.bind('reset', this.render);
      };

      CarouselView.prototype.render = function() {
        $(this.el).html(_.template(CarouselTemplate, {
          id: this.id
        }));
        _.each(this.collection.models, (function(item) {
          return this.renderItem(item);
        }), this);
        $('div.carousel-inner div:first-child', this.el).addClass('active');
        if (this.started) {
          $('.icon-play', this.el).removeClass('inactive');
          $('.icon-stop', this.el).addClass('inactive');
        } else {
          $('.icon-stop', this.el).removeClass('inactive');
          $('.icon-play', this.el).addClass('inactive');
        }
        return this;
      };

      CarouselView.prototype.stop = function() {
        Bronson.stop(this.moduleId);
        $('.icon-stop', this.el).removeClass('inactive');
        $('.icon-play', this.el).addClass('inactive');
        return this.started = false;
      };

      CarouselView.prototype.start = function() {
        Bronson.start(this.moduleId);
        $('.icon-play', this.el).removeClass('inactive');
        $('.icon-stop', this.el).addClass('inactive');
        return this.started = true;
      };

      CarouselView.prototype.renderItem = function(item) {
        var carouselItemView;
        carouselItemView = new CarouselItemView({
          model: item
        });
        return $('div.carousel-inner', this.el).append(carouselItemView.render().el);
      };

      CarouselView.prototype.dispose = function() {
        Bronson.unload(this.moduleId);
        this.collection.unbind('change');
        this.collection.dispose();
        return $(this.el).remove();
      };

      return CarouselView;

    })(Backbone.View);
  });

}).call(this);
