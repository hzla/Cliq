MobileSearch = 
	init: ->
		$('body').on 'ajax:success', '#search-form.mobile', @swipeUpToResults

	swipeUpToResults: ->
		console.log "tried"
		$('#search-container').addClass('animated fadeOutDownBig')
		$('#results-container').show().addClass('animated fadeInDownBig')



ready = ->
	MobileSearch.init()
$(document).ready ready
$(document).on 'page:load', ready
