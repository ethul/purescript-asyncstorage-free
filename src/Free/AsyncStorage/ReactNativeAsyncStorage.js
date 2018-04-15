'use strict';

var AsyncStorage = require('react-native').AsyncStorage;

exports.asyncStorage_ = function asyncStorage_(fn) {
  return function (args) {
    return function (onError, onSuccess) {
      var promise = AsyncStorage[fn].apply(AsyncStorage, args);

      promise.then(function (result) {
        onSuccess(result);
      }).catch (function (error) {
        onError(error);
      });

      return function () {
      };
    };
  };
};
