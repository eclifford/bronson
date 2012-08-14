define [
  'cs!build/bronson',
  'cs!test/fixtures/TestModule'
], (Bronson, TestModule) ->  
  buster.spec.expose()

  describe "Core", ->
    beforeAll ->

    afterAll ->

    describe "subscribe()", ->
      it "should successfully subscribe given valid paramaters", ->
        spy = sinon.spy()
        Bronson.Core.subscribe 'TestModule', 'TestEvent', spy
        Bronson.Core.publish 'TestEvent'
        Bronson.Core.unsubscribe 'TestModule', 'TestEvent' 
        assert.calledOnce spy

      it "should successfully recieve data passed to it", ->
        spy = sinon.spy()
        Bronson.Core.subscribe 'TestModule', 'TestEvent', spy
        Bronson.Core.publish 'TestEvent', {foo: 'bar'}
        Bronson.Core.unsubscribe 'TestModule', 'TestEvent' 
        assert.calledOnceWith spy, {foo: 'bar'}

      it "should throw if passed invalid paramaters", ->
        assert.exception ->
          Bronson.Core.subscribe 8, 8 
        , "Error"

    describe "unsubscribe()", ->
      it "should successfully unsubscribe", ->
        spy = sinon.spy()
        Bronson.Core.subscribe 'TestModule', 'TestEvent', spy
        Bronson.Core.unsubscribe 'TestModule', 'TestEvent' 
        Bronson.Core.publish 'TestEvent'
        refute.calledOnce spy

    describe "unsubscribeAll()", ->
      it "should successfully remove all subscribed channels from subscriber", ->
        refute.exception ->
          Bronson.Core.subscribe 'TestModule', 'TestEvent' 
          Bronson.Core.subscribe 'TestModule', 'TestEvent2' 
          Bronson.Core.subscribe 'TestModule', 'TestEvent3' 
          Bronson.Core.unsubscribeAll 'TestModule' 
          assert.equals Bronson.Core.events, {}

    describe "loadModule()", ->
      it "should successfully load a module", (done) ->
        Bronson.Core.loadModule 'test/fixtures/TestModule', {}, (module) ->
          assert.isFunction module.unload
          assert.isFunction module.load
          done()
        , false
  
    describe "stopModule()", ->
      it "should succesfully stop a module without erroring", (done) ->
        refute.exception ->
          Bronson.Core.loadModule 'test/fixtures/TestModule', {}, (module) ->
            Bronson.Core.stopModule module.id 
            assert.equals module.started, false
            done()
          , true

    describe "stopAllModules()", ->
      it "should succesfully stop all modules", (done) ->
        refute.exception ->
          Bronson.Core.loadModule 'test/fixtures/TestModule', {}, (module) ->
            Bronson.Core.stopAllModules()
            assert.equals module.started, false
            done()
          , true

    describe "startModule()", ->
      it "should succesfully stop a module without erroring", (done) ->
        refute.exception ->
          Bronson.Core.loadModule 'test/fixtures/TestModule', {}, (module) ->
            Bronson.Core.startModule module.id 
            assert.equals module.started, true
            done()
          , false

    # describe "unloadModule()", ->
    #   it "should successfully unload a module", (done) ->
    #     refute.exception ->
    #       Bronson.Core.loadModule 'test/fixtures/TestModule', {}, (module) ->
    #         Bronson.Core.unloadModule module.id
    #         done()
    #       , false

    





