app = angular.module 'app'

app.factory 'CDCService', ($q, $http, $log) ->
		getData: (year) -> 
			#deferred only for demonstration's sake
			deferred = $q.defer()
			url = "/api/incidences/#{year || ''}"

			$log.debug 'fetching CDC data from:', url
			
			$http.get(url).then (response) ->
				$log.debug 'CDCService Data:', response
				deferred.resolve response
			
			deferred.promise

app.factory 'ReferenceService', ($q, $http, $log) ->
	getRefData: -> 
		$http.get '/api/referenceData/'


app.factory 'jsonInterceptor', ($q, $log) ->
	response: (response) ->
		if response.headers()['content-type'] is 'application/json'
			# return the data object from response if it exists. 
			# This keeps us from having to always deferring our service calls to return
			# response.data. Saves me typing and keeps me DRY.
			return response.data if response.data
			
		return response

	responseError: (response) ->
		$q.reject response