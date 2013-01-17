(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'apps/lib/instagram/views/carouselView', 'apps/lib/instagram/collection/imagesCollection'], function($, _, Backbone, CarouselView, ImagesCollection) {
    var InstagramModule;
    return InstagramModule = (function(_super) {

      __extends(InstagramModule, _super);

      function InstagramModule(config) {
        if (config == null) {
          config = {};
        }
        this.el = config.el;
      }

      InstagramModule.prototype.load = function() {
        var _this = this;
        this.imagesCollection = new ImagesCollection();
        this.carouselView = new CarouselView({
          collection: this.imagesCollection
        });
        this.carouselView.moduleId = this.id;
        return this.imagesCollection.fetch({
          data: {
            client_id: "b3481714257943a4974e4e7ba99eb357",
            lat: "35.689488",
            lng: "139.691706"
          },
          silent: true,
          success: function() {
            return $(_this.el).append(_this.carouselView.render().el);
          }
        });
      };

      InstagramModule.prototype.start = function() {
        var _this = this;
        Bronson.subscribe('instagram:app:geoupdate', function(data) {
          return _this.imagesCollection.fetch({
            data: {
              client_id: "b3481714257943a4974e4e7ba99eb357",
              lat: data.latitude,
              lng: data.longitude
            },
            silent: false
          });
        });
        return InstagramModule.__super__.start.call(this);
      };

      InstagramModule.prototype.stop = function() {
        Bronson.unsubscribe('instagram');
        return InstagramModule.__super__.stop.call(this);
      };

      InstagramModule.prototype.unload = function() {
        return InstagramModule.__super__.unload.call(this);
      };

      return InstagramModule;

    })(Bronson.Module);
  });

}).call(this);
