define [
  'lib/bronson'
], (Bronson) ->
  describe "Bronson", ->
    describe "subscribe()", ->
      it "should successfully subscribe given valid paramaters", ->
        spy = sinon.spy()
        Bronson.subscribe 'searchview:grid:change', spy
        Bronson.publish 'grid:change'
        Bronson.unsubscribe 'searchview'
        expect(spy.calledOnce).to.equal(true)

      it "should successfully receive data passed to it", ->
        spy = sinon.spy()
        Bronson.subscribe 'searchview:grid:change', spy
        Bronson.publish 'grid:change', {foo: 'bar'}
        Bronson.unsubscribe 'searchview:grid:change' 
        expect(spy.calledWith({foo:'bar'})).to.be.true

      it "should throw if passed invalid paramaters", ->
        expect(=>
          Bronson.subscribe 'searchview:grid', spy
        ).to.throw(Error);
        expect(=>
          Bronson.subscribe 'searchview:grid:testing:testing', spy
        ).to.throw(Error);

    describe "unsubscribe()", ->
      it "should successfully unsubscribe one event", ->
        spy = sinon.spy()
        Bronson.subscribe 'searchview:grid:change', spy
        Bronson.unsubscribe 'searchview:grid:change'
        Bronson.publish 'grid:change'
        expect(spy.calledOnce).to.equal(false)

      it "should throw if passed invalid event", ->
        expect(=>
          Bronson.unsubscribe 'subscriber:channel'
        ).to.throw(Error);  

      it "should successfully unsubscribe all events", ->
        spy = sinon.spy()
        Bronson.subscribe "search:grid:one", spy
        Bronson.subscribe "search:grid:two", spy
        Bronson.subscribe "search:grid:three", spy
        Bronson.unsubscribe "search"
        Bronson.publish "grid:one"
        expect(spy.calledOnce).to.equal(false)
    describe "Bronson.Module", ->    
      describe "load()", ->
        it "should successfully load a module", (done) ->
          expect(=> 
            Bronson.load 'test/fixtures/TestModule', {}, (module) ->
              expect(module).to.respondTo('unload')
              expect(module).to.respondTo('load')
              done()
          ).to.not.throw()

      describe "stop()", ->
        it "should succesfully stop a module without erroring", (done) ->
          expect(=>
            Bronson.load 'test/fixtures/TestModule', {}, (module) ->
              Bronson.stop module.id 
              expect(module.started).to.equal(false)
              done()
            , false 
          ).to.not.throw()

      describe "stopAll()", ->
        it "should succesfully stop all modules", (done) ->
          expect(=>
            Bronson.load 'test/fixtures/TestModule', {}, (module) ->
              Bronson.start module.id
              Bronson.stopAll()
              expect(module.started).to.equal(false)
              done()
            , true
          ).to.not.throw()

      describe "startModule()", ->
        it "should succesfully stop a module without erroring", (done) ->
          expect(=> 
            Bronson.load 'test/fixtures/TestModule', {}, (module) ->
              #Bronson.start module.id 
              expect(module.started).to.equal(true)
              done()
            , true
          ).to.not.throw()

    describe "Bronson.Permissions", ->
      before ->
        @rules = 
          "search":
            "grid": true 

      describe "set()", ->
        it "should sucessfully set permissions", ->
          Bronson.Permissions.set @rules 
          expect(Bronson.Permissions.rules).to.deep.equal(@rules)

      describe "validate()", ->
        it "should succesfully validate permissions", ->
          Bronson.Permissions.enabled = true
          Bronson.Permissions.set @rules
          expect(=>
            Bronson.subscribe 'search:grid:one' 
            Bronson.unsubscribe 'search:grid:one'
          ).to.not.throw()
          Bronson.Permissions.enabled = false

      describe "Bronson.Util", ->

    describe "extend()", ->
      it "should sucessfully extend the an object", ->
        Foo =
          name: "baz"
        Bar =
          id: 13
        Bronson.Util.extend(Foo, Bar)
        expect(Foo).deep.equals
          name: "baz"
          id: 13
