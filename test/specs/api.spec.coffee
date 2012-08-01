define [
  'cs!build/bronson',
  'cs!test/fixtures/TestModule'
], (Bronson, TestModule) ->  
  buster.spec.expose()

  describe "Bronson.Api", ->
    beforeEach ->
      @spy = @spy()

    afterEach ->
      @spy.reset()

    describe "subscribe()", ->
      it "should successfully subscribe an event", ->
        Bronson.Api.subscribe 'TestModule', 'TestEvent', @spy
        Bronson.Api.publish 'TestEvent'
        Bronson.Api.unsubscribe 'TestModule', 'TestEvent'

        assert.calledOnce @spy

    describe "publish()", ->
      it "should successfully publish an event", ->
        Bronson.Api.subscribe 'TestModule', 'TestEvent', @spy
        Bronson.Api.publish 'TestEvent', {foo: 'bar'}
        Bronson.Api.unsubscribe 'TestModule', 'TestEvent'
        assert.calledOnceWith @spy, {foo: 'bar'}