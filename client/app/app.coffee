'use strict'

# prepare modules for parts, they will be filled in their respective files
angular.module('app.controllers', [])
angular.module('app.directives', [])
angular.module('app.filters', [])
angular.module('app.services', ['ngRessource'])

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngRoute'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
  'siyfion.sfTypeahead'
  'partials'
])

config = ($routeProvider, $locationProvider) ->

  $routeProvider
  .when('/welcome', templateUrl: '/partials/welcome.html')
  .otherwise({redirectTo: '/welcome'})

  # Without server side support html5 must be disabled.
  $locationProvider.html5Mode(false)
App.config ['$routeProvider', '$locationProvider', config]

