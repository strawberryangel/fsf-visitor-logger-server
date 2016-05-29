// server.js
//
// BASE SETUP
// =============================================================================
//
// call the packages we need
let express    = require('express')        // call express
let app        = express()                 // define our app using express
let router     = express.Router()          // get an instance of the express Router
let bodyParser = require('body-parser')

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

let port = process.env.PORT || 3000        // set our port

// ROUTES FOR OUR API
// =============================================================================
//
// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to our api!' })   
})


router.post('/agents/current', function(req, res) {
   res.json({ echo:  req.body.value})
   console.log("Body: ", req.body)
})

// more routes for our API will happen here
//
// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router)

// START THE SERVER
// =============================================================================
app.listen(port)
console.log('Magic happens on port ' + port)


