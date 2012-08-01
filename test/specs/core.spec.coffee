define [
  'cs!build/bronson',
  'cs!test/fixtures/TestModule'
], (R8, TestModule) ->  
  buster.spec.expose()

  describe "Core", ->

    beforeEach ->
      @spy = @spy()

    afterEach ->
      @spy.reset()

    describe "subscribe()", ->
      it "should successfully subscribe given valid paramaters", ->
        Bronson.Core.subscribe 'TestModule', 'TestEvent', @spy
        Bronson.Core.publish 'TestEvent'
        Bronson.Core.unsubscribe 'TestModule', 'TestEvent', ->
        assert.calledOnce @spy

      it "should successfully recieve data passed to it", ->
        Bronson.Core.subscribe 'TestModule', 'TestEvent', @spy
        Bronson.Core.publish 'TestEvent', {foo: 'bar'}
        Bronson.Core.unsubscribe 'TestModule', 'TestEvent', ->
        assert.calledOnceWith @spy, {foo: 'bar'}

      it "should throw if passed invalid paramaters", ->
        assert.exception ->
          Bronson.Core.subscribe 8, 8, ->
        , "Error"

    describe "unsubscribe()", ->
      it "should successfully unsubscribe", ->
        Bronson.Core.subscribe 'TestModule', 'TestEvent', @spy
        Bronson.Core.unsubscribe 'TestModule', 'TestEvent', ->
        Bronson.Core.publish 'TestEvent'
        refute.calledOnce @spy

    describe "createModule()", ->
      it "should successfully load a module", (done) ->
        Bronson.Core.createModule 'test/fixtures/TestModule', {}, (module) ->
          assert.isFunction module.dispose
          assert.isFunction module.initialize
          done()

