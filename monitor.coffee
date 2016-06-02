Avatar = require('./avatar/model').Avatar
api = require('./avatar/api')

## Process one avatar's entry in the HTTP request.
processLine = (value) ->
    [uuid, login, display] = value.split '|'
    return if not uuid? or not login?

    display ?= null

    ## TODO: Store data & update states . . . This is for testing.
    console.log "\nProcess Line"
    console.log "uuid   : ", uuid
    console.log "login  : ", login
    console.log "display: ", display

    avatar = new Avatar uuid, login, display
    api.save avatar
    .then (avatar) ->
        console.log "Successfully saved: ", avatar
    .catch (error) ->
        console.log "Failed to save avatar: ", error


## Decompose the HTTP request body into individual lines and
## have them processed.
processBody = (value) ->
    if not value?
        return {
            error: true
            message: "Body was empty."
        }

    lines = value.split "\n"

    console.log "\n------------------\n"
    console.log "processBody: ", lines

    for line in lines
        processLine line if line.length > 0

    return {
        error: false
    }


module.exports.processBody = processBody