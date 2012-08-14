define [
  'cs!build/bronson'
], (Bronson) ->  
  buster.spec.expose()

  describe "Bronson.Util", ->

    describe "extend()", ->
      it "should sucessfully extend the an object", ->
        Foo =
          name: "baz"
        Bar =
          id: 13
        Bronson.Util.extend(Foo, Bar)
        assert.equals Foo, 
          name: "baz"
          id: 13


