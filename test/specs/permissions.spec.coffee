define [
  'cs!build/bronson'
], (Bronson, TestModule) ->  
  buster.spec.expose()

  describe "Bronson.Permissions", ->

    before ->
      @rules = 
        "TestModule":
          "TestEvent": false

    describe "set()", ->
      it "should sucessfully set permissions", ->
        Bronson.Permissions.set @rules 
        assert.equals Bronson.Permissions.rules, @rules

    describe "validate()", ->
      it "should succesfully validate permissions", ->
        Bronson.Permissions.enabled = true
        Bronson.Permissions.set @rules
        refute.exception ->
          Bronson.Core.subscribe 'TestModule', 'TestEvent'
          Bronson.Core.unsubscribe 'TestModule', 'TestEvent', ->
        Bronson.Permissions.enabled = false
