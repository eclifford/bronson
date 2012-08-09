(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone', 'apps/lib/instagram/model/imageModel'], function(_, Backbone, ImageModel) {
    var ImagesCollection;
    return ImagesCollection = (function(_super) {

      __extends(ImagesCollection, _super);

      function ImagesCollection() {
        return ImagesCollection.__super__.constructor.apply(this, arguments);
      }

      ImagesCollection.prototype.model = ImageModel;

      ImagesCollection.prototype.url = "https://api.instagram.com/v1/media/search?callback=?";

      ImagesCollection.prototype.parse = function(response) {
        return response.data;
      };

      ImagesCollection.prototype.dispose = function() {
        this.reset([], {
          silent: true
        });
        this.off();
        return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
      };

      return ImagesCollection;

    })(Backbone.Collection);
  });

}).call(this);
