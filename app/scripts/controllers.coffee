'use strict'

### Controllers ###

app = angular.module('app')

app.controller 'AppController', ($scope, $location, $anchorScroll, ReferenceService) ->
	$scope.app = 
		title: 'Cancer -  United States Cancer Statistics (USCS)'
		scrollTo: (id) ->
			$location.hash(id)
			$anchorScroll();
  
	ReferenceService.getRefData().then (response) ->
		$scope.app.referenceData = response

app.controller 'MainController', ($scope, $filter, $log, CDCService) ->
	

	$scope.updateData = () ->
		CDCService.getData($scope.cdc?.year).then (response) ->
			$scope.cdc.data = response

	# initial values
	$scope.cdc = 
		sex: 'both'
		year: '2010'
		race: 'all'
		eventType: 'i'


	$scope.updateData()
	