'use strict';
var App, config;

angular.module('app.controllers', []);

angular.module('app.directives', []);

angular.module('app.filters', []);

angular.module('app.services', ['ngRessource']);

App = angular.module('app', ['ngRoute', 'app.controllers', 'app.directives', 'app.filters', 'app.services', 'partials']);

config = function($routeProvider, $locationProvider) {
  $routeProvider.when('/welcome', {
    templateUrl: '/partials/welcome.html'
  }).otherwise({
    redirectTo: '/welcome'
  });
  return $locationProvider.html5Mode(false);
};

App.config(['$routeProvider', '$locationProvider', config]);
;var AppCtrl;

AppCtrl = function($scope, $location, $resource, $rootScope) {
  return console.log("hey");
};

angular.module('app.controllers').controller('AppCtrl', ['$scope', '$location', '$resource', '$rootScope', AppCtrl]);
;var AppCtrl;

AppCtrl = function($scope, $location, $resource, $rootScope) {
  return console.log("hey");
};

angular.module('app.controllers').controller('AppCtrl', ['$scope', '$location', '$resource', '$rootScope', AppCtrl]);
;var factory;

angular.module('app.directives').directive('documentCard', [factory]);

factory = function() {
  return link;
};
;
//# sourceMappingURL=app.js.map