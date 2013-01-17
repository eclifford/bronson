var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define([], function() {
  var TestModule;
  return TestModule = (function(_super) {

    __extends(TestModule, _super);

    function TestModule() {
      return TestModule.__super__.constructor.apply(this, arguments);
    }

    TestModule.prototype.load = function() {};

    TestModule.prototype.start = function() {
      return TestModule.__super__.start.call(this);
    };

    TestModule.prototype.stop = function() {
      return TestModule.__super__.stop.call(this);
    };

    TestModule.prototype.unload = function() {};

    return TestModule;

  })(Bronson.Module);
});
