'use strict'

# Declare app level module which depends on filters, and services

app = angular.module('app', [
	'ngRoute'
	'partials'
	'ui.bootstrap'
])

app.config ($routeProvider, $locationProvider, $httpProvider) ->
	$routeProvider
		.when('/', {templateUrl: '/partials/main.html'})
		.otherwise({redirectTo: '/'})

	# Without server side support html5 must be disabled.
	$locationProvider.html5Mode(true)

	$httpProvider.interceptors.push 'jsonInterceptor'

