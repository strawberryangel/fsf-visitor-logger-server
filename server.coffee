## server.js
##
## BASE SETUP
## =============================================================================
##
## call the packages we need
express = require 'express' ## call express
app = express() ## define our app using express
router = express.Router() ## get an instance of the express Router
bodyParser = require 'body-parser'

## configure app to use bodyParser()
## this will let us get the data from a POST
app.use bodyParser.urlencoded {extended: true}

app.use bodyParser.json()

port = process.env.PORT || 3000 ## set our port

## Process one avatar's entry in the HTTP request.
processLine = (value) ->
    [uuid, login, display] = value.split '|'
    if not display?
        ## TODO: Handle bad lines
        return

    ## TODO: Store data & update states . . . This is for testing. 
    login = (login + " ".repeat 32).substr 0, 32
    display = (display + " ".repeat 32).substr 0, 32
    console.log uuid, login, display


## Decompose the HTTP request body into individual lines and
## have them processed. 
processBody = (value) ->
    lines = value.split "\n"
    return if lines.length is 1 && lines[0] is ''

    for line of lines
        processLine line


## ROUTES FOR OUR API
## =============================================================================
##
## test route to make sure everything is working (accessed at GET http:##localhost:8080/api)
router.get '/', (req, res) ->
    res.json {message: 'hooray! welcome to our api!'}


router.post '/agents/current', (req, res) ->
    processBody req.body.value
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


