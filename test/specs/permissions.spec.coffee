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
        Bronson.Permissions.set @rules
        refute.exception ->
          Bronson.Core.subscribe 'TestModule', 'TestEvent'
          Bronson.Core.unsubscribe 'TestModule', 'TestEvent', ->
        Bronson.Permissions.enabled = false
