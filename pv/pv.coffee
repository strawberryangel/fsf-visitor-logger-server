class PV
    constructor: (finalCallback, initialLockValue)  ->
        @_lock = initialLockValue ? initialLockValue: 0
        @_callback = finalCallback

    lock: -> @_lock++
    unlock: ->
        @_lock--
        @_callback() if @_lock == 0 && @_callback

module.exports.PV = PV

