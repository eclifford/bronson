define [
  'cs!build/bronson'
], (Bronson, TestModule) ->  
  buster.spec.expose()

  describe "Bronson.Permissions", ->

    before ->
      @rules = 
        "TestModule":
          "TestEvent": false

    describe "validate()", ->
      it "should succesfully validate permissions", ->
        Bronson.Permissions.enabled = true
        Bronson.Permissions.extend @rules
        refute.exception ->
          Bronson.Core.subscribe 'TestModule', 'TestEvent'
          Bronson.Core.unsubscribe 'TestModule', 'TestEvent'
        Bronson.Permissions.enabled = false


    # describe "subscribe()", ->
    #   it "should successfully subscribe given valid paramaters", ->
    #     R8.Core.subscribe 'TestModule', 'TestEvent', @spy
    #     R8.Core.publish 'TestEvent'
    #     R8.Core.unsubscribe 'TestModule', 'TestEvent', ->
    #     assert.calledOnce @spy

    #   it "should successfully recieve data passed to it", ->
    #     R8.Core.subscribe 'TestModule', 'TestEvent', @spy
    #     R8.Core.publish 'TestEvent', {foo: 'bar'}
    #     R8.Core.unsubscribe 'TestModule', 'TestEvent', ->
    #     assert.calledOnceWith @spy, {foo: 'bar'}

    #   it "should throw if passed invalid paramaters", ->
    #     assert.exception ->
    #       R8.Core.subscribe 8, 8, ->
    #     , "Error"

    # describe "unsubscribe()", ->
    #   it "should successfully unsubscribe", ->
    #     R8.Core.subscribe 'TestModule', 'TestEvent', @spy
    #     R8.Core.unsubscribe 'TestModule', 'TestEvent', ->
    #     R8.Core.publish 'TestEvent'
    #     refute.calledOnce @spy

    # describe "createModule()", ->
    #   it "should successfully load a module", (done) ->
    #     R8.Core.createModule 'test/fixtures/TestModule', {}, (module) ->
    #       console.log module.dispose, 'module'
    #       assert.isFunction module.dispose
    #       assert.isFunction module.initialize
    #       done()

