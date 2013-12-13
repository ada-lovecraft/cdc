# Serve JSON to our AngularJS client

bysite = require './repositories/bysite'
_ = require 'lodash'

raceLookup = 
	all: 'All Races' 
	american:'American Indian/Alaska Native' 
	asian: 'Asian/Pacific Islander'
	black: 'Black'
	hispanic: 'Hispanic'
	white: 'White'

sexLookup =
	m: 'Male'
	f: 'Female'
	both: 'Male and Female'

eventTypeLookup = 
	i: 'Incidence'
	m: 'Mortality'


exports.referenceData = (req, res) ->
	res.type 'json'
	res.json 
		races: raceLookup
		sexes: sexLookup
		eventTypes: eventTypeLookup
		years: _.chain(bysite.data)
				.uniq('year')
				.pluck('year')
				.value()

exports.incidencesByYear = (req, res) ->
	sex = sexLookup[req.query.sex] || sexLookup.both
	eventType = eventTypeLookup[req.query.eventType] || eventTypeLookup.i
	year = req.params.year || "2010"
	data = {}
	_.each _.keys(eventTypeLookup), (eventType) ->
		sexObj = {}
		_.each _.keys(sexLookup), (sex) ->
			
			dataObj = {}

			_.each _.keys(raceLookup), (race) ->
				dataObj[race] = _.chain(bysite.data)
					.where({year: year, eventType: eventTypeLookup[eventType], sex: sexLookup[sex], race: raceLookup[race]})
					.reject( (obj) -> obj.site is 'All Sites (comparable to ICD-O-2)' or obj.site is 'All Cancer Sites Combined' or obj.rate is '~')
					.transform( (result, obj) -> 
						obj.rate = parseFloat obj.rate
						result.push obj)
					.sortBy('rate')
					.reverse()
					.first(10)
					.value()
			sexObj[sex] = dataObj

		data[eventType] = sexObj
	
	res.type 'json'
	res.json data