(function() {
  var file, specRgx, tests;

  tests = [];

  for (file in window.__karma__.files) {
    if (window.__karma__.files.hasOwnProperty(file)) {
      specRgx = new RegExp("modules/.*/[0-9A-Za-z]*Spec.js");
      if (specRgx.test(file)) {
        tests.push(file);
      }
    }
  }

  requirejs.config({
    baseUrl: "/base/.tmp",
    deps: tests,
    callback: window.__karma__.start
  }, document.body.innerHTML += "<div id='fixtures'></div>");

}).call(this);
