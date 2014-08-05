MobileSearch = 
	init: ->
		$('body').on 'ajax:success', '#search-form.mobile:not(.big-search)', @swipeUpToResults
		$('body').on 'ajax:succss', '#search-form.mobile.big-search', @displayResults
		$('body').on 'click', '.search-icon', @swipeDownToSearch
		$('body').on 'click', '.quick-search-button', @submitSearch

	submitSearch: ->
		$('#search-form').submit()

	swipeUpToResults: (event, data, xhr, status) ->
		$('#search-results').html data
		$('.result').addClass 'animated fadeIn'
		$('#results').html data
		$('.swiped-result').hide()
		$('.swiped-result').first().show().addClass 'animated fadeIn'
		$('#search-container').addClass('animated fadeOutDownBig')
		$('#results-container').show().removeClass().addClass('mobile animated fadeInDownBig')
		
		if $('#empty:visible').length > 0
			console.log "no one"
			$('#no-one-around').show()
			$("#results").swipe 
				swipe: (event, direction, distance, duration, fingerCount) ->
					console.log distance
					MobileSearch.swipeDownToSearch() if direction == "up"
				threshold: 130
		else
			$(".swiped-actions").swipe 
	  		swipe: (event, direction, distance, duration, fingerCount) ->
	    		MobileSearch.swipeDownToSearch() if direction == "up"
	    	threshold: 16 
		
		
	

	swipeDownToSearch: ->
		$('#results-container').addClass('animated fadeOutUpBig')
		$('#search-container').show().removeClass().addClass('mobile animated fadeInUpBig')
		$('#search-query').css 'bottom', '100px'
		
 	 
ready = ->
	MobileSearch.init()
$(document).ready ready
$(document).on 'page:load', ready
