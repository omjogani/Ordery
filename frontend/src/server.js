var express = require('express')
var request = require('request')
var cors = require('cors')
var app = express()

app.use(cors())

app.use('/', function(req, res) {
  var url = 'https://' +
    req.get('host').replace('localhost:80', 'servername.domain:11121') + 
    req.url
  req.pipe(request({ qs:req.query, uri: url })).pipe(res);
})

app.listen(80, function () {
  console.log('CORS-enabled web server listening on port 80')
})