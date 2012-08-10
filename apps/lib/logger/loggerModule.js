(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'bronson'], function($, Bronson) {
    var Logger;
    return Logger = (function(_super) {

      __extends(Logger, _super);

      function Logger(parameters) {
        if (parameters == null) {
          parameters = {};
        }
        this.el = parameters.el;
        Logger.__super__.constructor.apply(this, arguments);
      }

      Logger.prototype.load = function() {
        Bronson.Api.subscribe('logger', 'logevent', function() {});
        return Bronson.Api.publish('moduleLoaded', {
          type: 'Logger',
          id: this.id
        });
      };

      Logger.prototype.start = function() {
        var _this = this;
        Bronson.Api.subscribe('logger', 'logevent', function(event) {
          return $(_this.el).append("<div>" + event.msg + "</div>");
        });
        Bronson.Api.publish('moduleLoaded', {
          type: 'Logger',
          id: this.id
        });
        return $(this.el).html('Log Events');
      };

      Logger.prototype.stop = function() {
        return $(this.el).empty();
      };

      Logger.prototype.unload = function() {
        return Bronson.Api.unsubscribe('logger', 'logevent');
      };

      return Logger;

    })(Bronson.Module);
  });

}).call(this);
