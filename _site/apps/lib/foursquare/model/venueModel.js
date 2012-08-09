(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['underscore', 'backbone'], function(_, Backbone) {
    var VenueModel;
    return VenueModel = (function(_super) {

      __extends(VenueModel, _super);

      function VenueModel() {
        return VenueModel.__super__.constructor.apply(this, arguments);
      }

      return VenueModel;

    })(Backbone.Model);
  });

}).call(this);
