MobileSearch = 
	init: ->
		$('body').on 'ajax:success', '#search-form.mobile', @swipeUpToResults
		$('body').on 'click', '.search-icon', @swipeDownToSearch
		$('body').on 'swipeup', '#results-container', @swipeDownToSearch

	swipeUpToResults: ->
		$('#search-container').addClass('animated fadeOutDownBig')
		$('#results-container').show().removeClass().addClass('mobile animated fadeInDownBig')

	swipeDownToSearch: ->
		console.log "tried"
		$('#results-container').addClass('animated fadeOutUpBig')
		$('#search-container').show().removeClass().addClass('mobile animated fadeInUpBig')
		$('#search-query').css 'bottom', '100px'



ready = ->
	MobileSearch.init()
$(document).ready ready
$(document).on 'page:load', ready
