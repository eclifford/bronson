(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'modules/foursquare/views/venuesItemView', 'tpl!modules/foursquare/templates/venuesTemplate.html'], function(Marionette, VenuesItemView, VenuesTemplate) {
    var VenuesView, _ref;
    return VenuesView = (function(_super) {
      __extends(VenuesView, _super);

      function VenuesView() {
        _ref = VenuesView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      VenuesView.prototype.template = VenuesTemplate;

      VenuesView.prototype.itemView = VenuesItemView;

      VenuesView.prototype.itemViewContainer = '.content';

      VenuesView.prototype.className = 'module';

      VenuesView.prototype.events = function() {
        return {
          'click .glyphicon-remove': 'dispose',
          'click .glyphicon-stop': 'stop',
          'click .glyphicon-play': 'start'
        };
      };

      VenuesView.prototype.stop = function() {
        Bronson.stop(this.moduleId);
        $('.glyphicon-stop', this.el).addClass('active');
        $('.glyphicon-play', this.el).removeClass('active');
        return this.started = false;
      };

      VenuesView.prototype.start = function() {
        Bronson.start(this.moduleId);
        $('.glyphicon-stop', this.el).removeClass('active');
        $('.glyphicon-play', this.el).addClass('active');
        return this.started = true;
      };

      VenuesView.prototype.dispose = function() {
        return this.close();
      };

      return VenuesView;

    })(Marionette.CompositeView);
  });

}).call(this);
