mongo = require('mongodb').MongoClient
PV = require './pv'

class Connection
    constructor: (@url) ->
        @db = null

        ## Create semaphore to automatically close the connection
        ## when the resource is no longer used.
        @pv = new PV @_release

    @_release: ->
        if self.db?
            @db.close()
            @db = null

    @close: -> @pv.unlock()

    @execute: (callback) ->
        @pv.lock()
        callback @db
        @pv.unlock()

    @open: ->
        self = @

        ## Is the connection active?
        if @db?
            pv.lock()
            return

        mongo.connect @url, (err, connection) ->
            if err?
                self.db = connection
                self.pv.lock()
            else
                ## TODO: Handle this better
                console.log("Could not connect to database: ", err)

module.exports = Connection

##db = new Connection("localhost:fsf")
##db.open()
##db.execute(function(db){ ... })
##db.execute(function(db){ ... })
##db.execute(function(db){ ... })
##db.execute(function(db){ ... })
##db.close()
##
##db.open()
##db.execute(function(db){ ... })
##db.execute(function(db){ ... })
##db.execute(function(db){ ... })
##db.execute(function(db){ ... })
##db.close()
##
