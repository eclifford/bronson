define(['bronson'], function(Bronson) {
  var ModuleA = Bronson.Module.extend({

    events: {
      'app:test': 'event_test'
    },

    onLoad: function() {

    },
    onStart: function() {

    },
    onStop: function() {
      
    },
    onUnload: function() {

    },
    event_test: function() {
    }
  });
  return ModuleA;
});