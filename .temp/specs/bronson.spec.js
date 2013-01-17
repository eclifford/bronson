(function() {

  define(['lib/bronson'], function(Bronson) {
    return describe("Bronson", function() {
      describe("subscribe()", function() {
        it("should successfully subscribe given valid paramaters", function() {
          var spy;
          spy = sinon.spy();
          Bronson.subscribe('searchview:grid:change', spy);
          Bronson.publish('grid:change');
          Bronson.unsubscribe('searchview');
          return expect(spy.calledOnce).to.equal(true);
        });
        it("should successfully receive data passed to it", function() {
          var spy;
          spy = sinon.spy();
          Bronson.subscribe('searchview:grid:change', spy);
          Bronson.publish('grid:change', {
            foo: 'bar'
          });
          Bronson.unsubscribe('searchview:grid:change');
          return expect(spy.calledWith({
            foo: 'bar'
          })).to.be["true"];
        });
        return it("should throw if passed invalid paramaters", function() {
          var _this = this;
          expect(function() {
            return Bronson.subscribe('searchview:grid', spy);
          }).to["throw"](Error);
          return expect(function() {
            return Bronson.subscribe('searchview:grid:testing:testing', spy);
          }).to["throw"](Error);
        });
      });
      describe("unsubscribe()", function() {
        it("should successfully unsubscribe one event", function() {
          var spy;
          spy = sinon.spy();
          Bronson.subscribe('searchview:grid:change', spy);
          Bronson.unsubscribe('searchview:grid:change');
          Bronson.publish('grid:change');
          return expect(spy.calledOnce).to.equal(false);
        });
        it("should throw if passed invalid event", function() {
          var _this = this;
          return expect(function() {
            return Bronson.unsubscribe('subscriber:channel');
          }).to["throw"](Error);
        });
        return it("should successfully unsubscribe all events", function() {
          var spy;
          spy = sinon.spy();
          Bronson.subscribe("search:grid:one", spy);
          Bronson.subscribe("search:grid:two", spy);
          Bronson.subscribe("search:grid:three", spy);
          Bronson.unsubscribe("search");
          Bronson.publish("grid:one");
          return expect(spy.calledOnce).to.equal(false);
        });
      });
      describe("Bronson.Module", function() {
        describe("load()", function() {
          return it("should successfully load a module", function(done) {
            var _this = this;
            return expect(function() {
              return Bronson.load('test/fixtures/TestModule', {}, function(module) {
                expect(module).to.respondTo('unload');
                expect(module).to.respondTo('load');
                return done();
              });
            }).to.not["throw"]();
          });
        });
        describe("stop()", function() {
          return it("should succesfully stop a module without erroring", function(done) {
            var _this = this;
            return expect(function() {
              return Bronson.load('test/fixtures/TestModule', {}, function(module) {
                Bronson.stop(module.id);
                expect(module.started).to.equal(false);
                return done();
              }, false);
            }).to.not["throw"]();
          });
        });
        describe("stopAll()", function() {
          return it("should succesfully stop all modules", function(done) {
            var _this = this;
            return expect(function() {
              return Bronson.load('test/fixtures/TestModule', {}, function(module) {
                Bronson.start(module.id);
                Bronson.stopAll();
                expect(module.started).to.equal(false);
                return done();
              }, true);
            }).to.not["throw"]();
          });
        });
        return describe("startModule()", function() {
          return it("should succesfully stop a module without erroring", function(done) {
            var _this = this;
            return expect(function() {
              return Bronson.load('test/fixtures/TestModule', {}, function(module) {
                Bronson.start(module.id);
                expect(module.started).to.equal(true);
                return done();
              }, false);
            }).to.not["throw"]();
          });
        });
      });
      describe("Bronson.Permissions", function() {
        before(function() {
          return this.rules = {
            "search": {
              "grid": true
            }
          };
        });
        describe("set()", function() {
          return it("should sucessfully set permissions", function() {
            Bronson.Permissions.set(this.rules);
            return expect(Bronson.Permissions.rules).to.deep.equal(this.rules);
          });
        });
        describe("validate()", function() {
          return it("should succesfully validate permissions", function() {
            var _this = this;
            Bronson.Permissions.enabled = true;
            Bronson.Permissions.set(this.rules);
            expect(function() {
              Bronson.subscribe('search:grid:one');
              return Bronson.unsubscribe('search:grid:one');
            }).to.not["throw"]();
            return Bronson.Permissions.enabled = false;
          });
        });
        return describe("Bronson.Util", function() {});
      });
      return describe("extend()", function() {
        return it("should sucessfully extend the an object", function() {
          var Bar, Foo;
          Foo = {
            name: "baz"
          };
          Bar = {
            id: 13
          };
          Bronson.Util.extend(Foo, Bar);
          return expect(Foo).deep.equals({
            name: "baz",
            id: 13
          });
        });
      });
    });
  });

}).call(this);
