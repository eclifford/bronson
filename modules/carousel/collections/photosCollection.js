(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone'], function(_, Backbone) {
    var PhotosCollection, _ref;
    return PhotosCollection = (function(_super) {
      __extends(PhotosCollection, _super);

      function PhotosCollection() {
        _ref = PhotosCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PhotosCollection.prototype.url = 'https://api.instagram.com/v1/media/search?callback=?';

      PhotosCollection.prototype.parse = function(response) {
        return response.data;
      };

      return PhotosCollection;

    })(Backbone.Collection);
  });

}).call(this);
