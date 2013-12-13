app = angular.module 'app'

app.factory 'CDCService', ($q, $http, $log) ->
	return  {
		getData: (year) -> 
			deferred = $q.defer()
			url = "/api/incidences/#{year || ''}"
			$log.debug 'fetching data at:', url

			$http.get(url).then (response) ->
				$log.debug 'CDCService Data:', response.data
				deferred.resolve response.data
			deferred.promise
		}

app.factory 'ReferenceService', ($q, $http, $log) ->
	return  {
		getRefData: -> 
			deferred = $q.defer()
			url = "/api/referenceData/" 
			$http.get(url).then (response) ->
				$log.debug 'ReferenceService Data:', response.data
				deferred.resolve response.data
			deferred.promise
		}
