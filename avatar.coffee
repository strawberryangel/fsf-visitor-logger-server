COLLECTION_NAME = 'avatars'

class Avatar
    constructor: ->
        @uuid = null
        @username = null
        @displayName = null
        @born = null
        @payinfo =
            onFile: null,
            used: null

    @_toDatabase: ->
        {
            _id: @uuid
            username: @username
            displayName: @displayName
            born: @born
            paymentInfo:
                onFile: @payinfo.onFile
                used: @payinfo.used
        }

    @_isSameAsDatabase: (record)->
        return false if not record?
        return false if record._id isnt @uuid
        return false if record.username isnt @username
        return false if record.displayName isnt @displayName
        return false if record.paymentInfo?.onFile isnt @paymentInfo.onFile
        return false if record.paymentInfo?.used isnt @paymentInfo.used

        true

    @load: (connection, uuid) ->
        self = this

        connection.open()
        group = connection.collection COLLECTION_NAME
        search = {_id: uuid}
        group.findOne search
        .then (doc) ->
            if not doc?
                ##TODO: How to handle this
                console.log "Avatar.load() search failed: ", search
                connection.close()
                return

            ## Found record
            @uuid = doc._id
            @username = doc.username
            @displayName = doc.displayName
            @paymentInfo =
                onFile: doc.paymentInfo?.onFile
                used: doc.paymentInfo?.used

            connection.close()
        .catch (err) ->
            ## TODO: Handle this
            console.log "Search for avatar ", search, " failed: ", err
            connection.close()

    @save: (connection) ->
        self = this

        connection.open()
        group = connection.collection COLLECTION_NAME
        search = {_id: @uuid}
        group.findOne search
        .then (doc) ->
            if not doc?
                group.insertOne self._toDatabase(), (err) ->
                    if err?
                        ##TODO: How to handle this
                        console.log("Avatar.save() insert failed: ", err, self)
                        connection.close()
            else
                ## Found record
                if self._isSameAsDatabase doc
                    connection.close()
                    return

                ## Update record
                group.update self, (err) ->
                    if err?
                        ##TODO: How to handle this
                        console.log("Avatar.save() update failed: ", err, self)

                    connection.close()
        .catch (err) ->
            ## TODO: Handle this
            console.log("Search for avatar ", search, " failed: ", err)
            connection.close()


module.exports.Avatar = Avatar

