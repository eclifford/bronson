define [
  'cs!build/bronson',
  'cs!test/fixtures/TestModule'
], (Bronson, TestModule) ->  
  buster.spec.expose()

  describe "Bronson.Module", ->

    before ->
      @module = new TestModule()

    describe "load()", ->  
      it "should container a load method", ->
        refute.exception =>
          @module.load()

    describe "start()", ->
      it "should container a start method", ->
        refute.exception =>
          @module.start()

    describe "stop()", ->
      it "should container a stop method", ->
        refute.exception =>
          @module.stop()

    describe "unload()", ->
      it "should container a unload method", ->
        refute.exception =>
          @module.unload()



