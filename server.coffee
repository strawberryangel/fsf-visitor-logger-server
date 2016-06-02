## server.js
##
## BASE SETUP
## =============================================================================
##
## call the packages we need
express = require 'express' ## call express
bodyParser = require 'body-parser'
monitor = require './monitor'

app = express() ## define our app using express

## configure app to use bodyParser()
## this will let us get the data from a POST
app.use bodyParser.urlencoded {extended: true}
app.use bodyParser.json()

port = process.env.PORT || 3000 ## set our port

## ROUTES FOR OUR API
## =============================================================================
##
## test route to make sure everything is working (accessed at GET http:##localhost:8080/api)
router = express.Router() ## get an instance of the express Router
router.get '/', (req, res) ->
    res.json {message: 'hooray! welcome to our api!'}

router.post '/agents/current', (req, res) ->
    monitor.processBody req.body.value
    res.json {ack: true}

## more routes for our API will happen here
##
## REGISTER OUR ROUTES -------------------------------
## all of our routes will be prefixed with /api
app.use '/api', router

## START THE SERVER
## =============================================================================
app.listen port
console.log 'Magic happens on port ' + port


