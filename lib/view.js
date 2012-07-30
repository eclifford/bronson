(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  R8.View = (function(_super) {

    __extends(View, _super);

    View.prototype.subviews = null;

    View.prototype.subviewsByName = null;

    function View() {
      View.__super__.constructor.apply(this, arguments);
    }

    View.prototype.initialize = function(options) {
      this.subviews = [];
      this.subviewsByName = {};
      return logger.log(1, "--- View: initialize()");
    };

    View.prototype.subview = function(name, view) {
      if (name && view) {
        this.removeSubview(name);
        this.subviews.push(view);
        this.subviewsByName[name] = view;
        view;
      } else if (name) {
        this.subviewsByName[name];
      }
      return logger.log(1, "--- View: subview(" + name + ")");
    };

    View.prototype.removeSubview = function(nameOrView) {
      var index, name, otherName, otherView, view, _ref;
      if (!nameOrView) return;
      if (typeof nameOrView === 'string') {
        name = nameOrView;
        view = this.subviewsByName[name];
      } else {
        view = nameOrView;
        _ref = this.subviewsByName;
        for (otherName in _ref) {
          otherView = _ref[otherName];
          if (view === otherView) {
            name = otherName;
            break;
          }
        }
      }
      if (!(name && view && view.dispose)) return;
      view.dispose();
      index = _(this.subviews).indexOf(view);
      if (index > -1) this.subviews.splice(index, 1);
      delete this.subviewsByName[name];
      return logger.log(1, "--- View: removeSubView(" + nameOrView + ")");
    };

    View.prototype.render = function() {
      throw new Error('View#render must be overridden');
    };

    View.prototype.disposed = false;

    View.prototype.dispose = function() {
      var prop, properties, subview, _i, _j, _len, _len2, _ref;
      if (this.disposed) return;
      _ref = this.subviews;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        subview = _ref[_i];
        subview.dispose();
      }
      this.$el.remove();
      properties = ['el', '$el', 'options', 'model', 'collection', 'subviews', 'subviewsByName', '_callbacks'];
      for (_j = 0, _len2 = properties.length; _j < _len2; _j++) {
        prop = properties[_j];
        delete this[prop];
      }
      this.disposed = true;
      if (typeof Object.freeze === "function") Object.freeze(this);
      return logger.log(1, "--- View: dispose()");
    };

    return View;

  })(Backbone.View);

}).call(this);
