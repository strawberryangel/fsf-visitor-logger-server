class Avatar
    constructor: (uuid, username, displayName) ->
        @uuid = uuid ? null
        @username = username ? null
        @displayName = displayName ? null
        @born = null
        @payinfo =
            onFile: null,
            used: null

module.exports.Avatar = Avatar

