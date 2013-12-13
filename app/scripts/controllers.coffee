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
	$scope.cdc = 
		sex: 'both'
		year: '2010'
		race: 'all'
		eventType: 'i'
	$scope.updateData = () ->
		$log.debug 'updating CDC Data'
		CDCService.getData($scope.cdc?.year).then (response) ->
			_.extend $scope.cdc.data = response
			$log.debug '$scope.cdc', $scope.cdc

	$scope.updateData()
	