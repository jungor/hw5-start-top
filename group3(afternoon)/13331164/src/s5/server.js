(function(){
  var express, http, path, app, exports;
  express = require('express');
  http = require('http');
  path = require('path');
  app = express();
  app.get('/', function(req, res){
    var from;
    from = req.param('from');
    setTimeout(function(){
      var random;
      res.set('Content-Type', 'text/plain');
      res.send('' + (random = Math.floor(Math.random() * 10)));
    }, 1000 + Math.random() * 2000);
  });
  exports = module.exports = app;
}).call(this);