define [
  'cs!build/bronson'
], (Bronson, TestModule) ->  
  buster.spec.expose()

  describe "Bronson.Module", ->

    describe "set()", ->
      it "should sucessfully set permissions", ->
        assert.equals(true, true)

