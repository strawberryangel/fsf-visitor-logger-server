q = require 'q'
grid = require '../mongo/grid'

COLLECTION_NAME = 'avatars'

class AvatarAPI
    constructor: (databaseConnection) ->
        @connection = databaseConnection

    fromDatabase: (dbDoc) ->
        avatar.uuid = dbDoc._id
        avatar.username = dbDoc.username
        avatar.displayName = dbDoc.displayName
        avatar.paymentInfo =
            onFile: dbDoc.paymentInfo?.onFile
            used: dbDoc.paymentInfo?.used

    toDatabase: (avatar) ->
        {
            _id: avatar.uuid
            username: avatar.username
            displayName: avatar.displayName
            born: avatar.born
            paymentInfo:
                onFile: avatar.payinfo.onFile
                used: avatar.payinfo.used
        }

    isEqual: (a, b)->
        return false if not a? or not b?
        return false if a.uuid isnt b.uuid
        return false if a.username isnt b.username
        return false if a.displayName isnt b.displayName
        return false if a.paymentInfo?.onFile isnt b.paymentInfo.onFile
        return false if a.paymentInfo?.used isnt b.paymentInfo.used

        true

    load: (uuid) ->
        self = @
        deferral = q.defer()

        @connection.open()
        group = @connection.collection COLLECTION_NAME
        search = {_id: uuid}
        group.findOne search
        .then (doc) ->
            self.connection.close()
            if not doc?
                deferral.reject "Avatar not found."
                return

            ## Found record
            result =
                uuid: doc._id
                username: doc.username
                displayName: doc.displayName
                paymentInfo:
                    onFile: doc.paymentInfo?.onFile
                    used: doc.paymentInfo?.used

            deferral.resolve result
        .catch (err) ->
            self.connection.close()
            deferral.reject "Database failure: #{err}"

        deferral.promise

    save: (avatar) ->
        self = @
        deferral = q.defer()
        if not avatar?
            deferral.reject "Could not save avatar."
            return

        @connection.open()
        group = @connection.collection COLLECTION_NAME
        search = {_id: @uuid}
        group.findOne search
        .then (doc) ->
            if not doc?
                group.insertOne self.toDatabase(), (err) ->
                    if err?
                        ##TODO: How to handle this
                        console.log("Avatar.save() insert failed: ", err, self)
                        self.connection.close()
            else
                ## Found record
                if self._isSameAsDatabase doc
                    self.connection.close()
                    return

                ## Update record
                group.update self, (err) ->
                    if err?
                        ##TODO: How to handle this
                        console.log("Avatar.save() update failed: ", err, self)

                    self.connection.close()
        .catch (err) ->
            ## TODO: Handle this
            console.log("Search for avatar ", search, " failed: ", err)
            self.connection.close()

module.exports = new AvatarAPI grid
