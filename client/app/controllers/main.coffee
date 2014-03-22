AppCtrl = ($scope,  $location,  $resource,  $rootScope) ->
  console.log("hey")


angular.module('app.controllers')
.controller 'AppCtrl', ['$scope','$location','$resource','$rootScope', AppCtrl]