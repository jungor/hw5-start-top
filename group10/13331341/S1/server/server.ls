require! {express, http, path,}

webapp = express!

webapp.get '/api/random', (req, res)!-> 
  from = req.param 'from'
  set-timeout !->
    res.set 'Content-Type', 'text/plain'
    res.send '' + random = Math.floor Math.random! * 10
    console.log "Request from #{from}, answer random number: #{random}"
  , 1000ms + Math.random! * 2000ms

exports = module.exports = webapp
