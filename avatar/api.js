// Generated by CoffeeScript 1.10.0
(function() {
  var AvatarAPI, COLLECTION_NAME, mongo, q, singleton;

  q = require('q');

  mongo = require('mongo');

  COLLECTION_NAME = 'avatars';

  AvatarAPI = (function() {
    function AvatarAPI(databaseConnection) {
      this.connection = databaseConnection;
    }

    AvatarAPI.prototype.fromDatabase = function(dbDoc) {
      var ref, ref1;
      avatar.uuid = dbDoc._id;
      avatar.username = dbDoc.username;
      avatar.displayName = dbDoc.displayName;
      return avatar.paymentInfo = {
        onFile: (ref = dbDoc.paymentInfo) != null ? ref.onFile : void 0,
        used: (ref1 = dbDoc.paymentInfo) != null ? ref1.used : void 0
      };
    };

    AvatarAPI.prototype.toDatabase = function(avatar) {
      return {
        _id: avatar.uuid,
        username: avatar.username,
        displayName: avatar.displayName,
        born: avatar.born,
        paymentInfo: {
          onFile: avatar.payinfo.onFile,
          used: avatar.payinfo.used
        }
      };
    };

    AvatarAPI.prototype.isEqual = function(a, b) {
      var ref, ref1;
      if ((a == null) || (b == null)) {
        return false;
      }
      if (a.uuid !== b.uuid) {
        return false;
      }
      if (a.username !== b.username) {
        return false;
      }
      if (a.displayName !== b.displayName) {
        return false;
      }
      if (((ref = a.paymentInfo) != null ? ref.onFile : void 0) !== b.paymentInfo.onFile) {
        return false;
      }
      if (((ref1 = a.paymentInfo) != null ? ref1.used : void 0) !== b.paymentInfo.used) {
        return false;
      }
      return true;
    };

    AvatarAPI.prototype.load = function(uuid) {
      var deferral, group, search, self;
      self = this;
      deferral = q.defer();
      this.connection.open();
      group = this.connection.collection(COLLECTION_NAME);
      search = {
        _id: uuid
      };
      group.findOne(search).then(function(doc) {
        var ref, ref1, result;
        self.connection.close();
        if (doc == null) {
          deferral.reject("Avatar not found.");
          return;
        }
        result = {
          uuid: doc._id,
          username: doc.username,
          displayName: doc.displayName,
          paymentInfo: {
            onFile: (ref = doc.paymentInfo) != null ? ref.onFile : void 0,
            used: (ref1 = doc.paymentInfo) != null ? ref1.used : void 0
          }
        };
        return deferral.resolve(result);
      })["catch"](function(err) {
        self.connection.close();
        return deferral.reject("Database failure: " + err);
      });
      return deferral.promise;
    };

    AvatarAPI.prototype.save = function(avatar) {
      var deferral, group, search, self;
      self = this;
      deferral = q.defer();
      if (avatar == null) {
        deferral.reject("Could not save avatar.");
        return;
      }
      connection.open();
      group = connection.collection(COLLECTION_NAME);
      search = {
        _id: this.uuid
      };
      return group.findOne(search).then(function(doc) {
        if (doc == null) {
          return group.insertOne(self.toDatabase(), function(err) {
            if (err != null) {
              console.log("Avatar.save() insert failed: ", err, self);
              return connection.close();
            }
          });
        } else {
          if (self._isSameAsDatabase(doc)) {
            connection.close();
            return;
          }
          return group.update(self, function(err) {
            if (err != null) {
              console.log("Avatar.save() update failed: ", err, self);
            }
            return connection.close();
          });
        }
      })["catch"](function(err) {
        console.log("Search for avatar ", search, " failed: ", err);
        return connection.close();
      });
    };

    return AvatarAPI;

  })();

  singleton = new AvatarAPI();

  module.exports = singleton;

}).call(this);

//# sourceMappingURL=api.js.map
