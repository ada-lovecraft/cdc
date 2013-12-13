'use strict'

# Declare app level module which depends on filters, and services

App = angular.module('app', [
	'ngRoute'
	'partials'
	'ui.bootstrap'
])

App.config([
	'$routeProvider'
	'$locationProvider'
	($routeProvider, $locationProvider, config) ->
		$routeProvider
			.when('/', {templateUrl: '/partials/main.html'})
			.otherwise({redirectTo: '/'})

		# Without server side support html5 must be disabled.
		$locationProvider.html5Mode(true)
])
