define [
  'cs!build/r8',
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
        R8.Core.subscribe 'TestModule', 'TestEvent', @spy
        R8.Core.publish 'TestEvent'
        R8.Core.unsubscribe 'TestModule', 'TestEvent'
        assert.calledOnce @spy

      it "should successfully recieve data passed to it", ->
        R8.Core.subscribe 'TestModule', 'TestEvent', @spy
        R8.Core.publish 'TestEvent', {foo: 'bar'}
        R8.Core.unsubscribe 'TestModule', 'TestEvent'
        assert.calledOnceWith @spy, {foo: 'bar'}

      it "should throw if passed invalid paramaters", ->
        assert.exception ->
          R8.Core.subscribe 8, 8, ->
        , "Error"

    describe "unsubscribe()", ->
      it "should successfully unsubscribe", ->
        R8.Core.subscribe 'TestModule', 'TestEvent', @spy
        R8.Core.unsubscribe 'TestModule', 'TestEvent'
        R8.Core.publish 'TestEvent'
        refute.calledOnce @spy

    describe "createModule()", ->
      it "should successfully load a module", (done) ->
        R8.Core.createModule 'test/fixtures/TestModule', {}, (module) ->
          assert.isFunction module.dispose
          assert.isFunction module.initialize
          done()

