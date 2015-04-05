(function(){
  var express, http, path, app, exports;
  express = require('express');
  http = require('http');
  path = require('path');
  app = express();
  app.get('/api/random/?*?', function(req, res){
    var from;
    from = req.param('from');
    setTimeout(function(){
      var random;
      res.set('Content-Type', 'text/plain');
      res.send('' + (random = Math.floor(Math.random() * 10)));
      console.log("Request from " + from + ", answer random number: " + random);
    }, 1000 + Math.random() * 1000);
  });
  exports = module.exports = app;
}).call(this);
