define(['bronson'], function(Bronson) {
  describe("Bronson", function() {
    describe("subscribe()", function() {
      it("should successfully subscribe given valid parameters", function() {
        var spy = sinon.spy();
        Bronson.subscribe('searchview:grid:change', spy);
        Bronson.publish('grid:change');
        Bronson.unsubscribe('searchview');
        expect(spy).to.have.been.called;
      });

      it("should successfully recieve data passed to it", function() {
        var spy = sinon.spy();
        Bronson.subscribe('searchview:grid:change', spy);
        Bronson.publish('grid:change', {foo: 'bar'});
        Bronson.unsubscribe('searchview');
        expect(spy).to.have.been.calledWith({foo: 'bar'});
      });

      it("should throw if passed invalid parameters", function() {
        expect(function() {
         Bronson.subscribe('searchview:grid');
        }).to.throw(Error);
        expect(function() {
          Bronson.subscribe("searchview:grid:testing:testing");
        });
      });
    });

    describe("publish()", function() {
      it("should not throw when publishing to a nonexistent event", function() {
        var spy = sinon.spy();
        expect(function() {
          Bronson.publish('searchview:doesntexist');
        }).to.not.throw(Error);
      });
    });

    describe("unsubscribe()", function() {
      it("should successfully unsubscribe one event", function() {
        var _spy = sinon.spy();
        Bronson.subscribe('searchview:grid:change', _spy);
        Bronson.unsubscribe('searchview:grid:change');
        Bronson.publish('grid:change');
        expect(_spy).to.not.have.been.called;
      });

      it("should succesfully unsubscribe all events", function() {
        var spy = sinon.spy();
        Bronson.subscribe('searchview:grid:a', spy);
        Bronson.subscribe('searchview:grid:b', spy);
        Bronson.subscribe('searchview:grid:c', spy);
        Bronson.unsubscribe('searchview');
        Bronson.publish('grid:a');
        Bronson.publish('grid:b');
        Bronson.publish('grid:c');
        expect(spy).to.not.have.been.called;
      });

      it("should throw if passed invalid event", function() {
        expect(function() {
          Bronson.unsubscribe('subscriber:channel');
        }).to.throw(Error);
      });
    });

    describe("Bronson.Module", function() {
      describe("load()", function() {
        it("should successfully load a module", function(done) {
          expect(function() {
            Bronson.load(
              {
                id: 'foo3',
                path: 'test/fixtures/module',
                success: function(module) {
                  done();
                }
              }
            );
          }).to.not.throw();
        });
      });

      describe("stop()", function() {
        it("should successfully stop a module without erroring", function(done) {
          expect(function() {
            Bronson.load(
              {
                id: 'foo1',
                path: 'test/fixtures/module',
                success: function(module) {
                  Bronson.stop(module.id);
                  expect(module.started).to.equal(false);
                  done();
                }
              }
            );
          }).to.not.throw();
        });
      });

      describe("start()", function() {
        it("should successfully start a module", function(done) {
          expect(function() {
            Bronson.load(
              {
                id: 'foo2',
                path: 'test/fixtures/module',
                success: function(module) {
                  Bronson.stop(module.id);
                  expect(module.started).to.equal(false);
                  done();
                }
              }
            );
          }).to.not.throw();  
        });  
      });
    });

    describe("Bronson.Permissions", function() {
      var rules;
      before(function() {
        rules = {
          "search": {
            "grid": true 
          }
        };
      });

      describe("set()", function() {
        it("should successfully set permissions", function() {
          Bronson.Permissions.set(rules);
          expect(Bronson.Permissions.rules).to.deep.equal(rules);
        });
      });

      describe("validate()", function() {
        it("should successfully validate permissions", function() {
          Bronson.settings.permissions = true;
          Bronson.Permissions.set(rules);
          expect(function() {
            Bronson.subscribe('search:grid:one');
            Bronson.unsubscribe('search:grid:one');
          }).to.not.throw();
          Bronson.settings.permissions = false;
        });
      });
    });
  });
});


