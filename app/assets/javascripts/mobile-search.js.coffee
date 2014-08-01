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
		if $('#empty:visible').length > 0
			$('#no-one-around').show()
			$("#results").swipe 
				swipe: (event, direction, distance, duration, fingerCount) ->
					MobileSearch.swipeDownToSearch() if direction == "up"
				threshold: 500
		$('#found').text "Please enter a valid location." if $('#invalid').length > 0
		$('#search-container').addClass('animated fadeOutDownBig')
		$('#results-container').show().removeClass().addClass('mobile animated fadeInDownBig')
		$(".swiped-actions").swipe 
  		swipe: (event, direction, distance, duration, fingerCount) ->
    		MobileSearch.swipeDownToSearch() if direction == "up"
    	threshold: 50 

	swipeDownToSearch: ->
		$('#results-container').addClass('animated fadeOutUpBig')
		$('#search-container').show().removeClass().addClass('mobile animated fadeInUpBig')
		$('#search-query').css 'bottom', '100px'
		
 	 
ready = ->
	MobileSearch.init()
$(document).ready ready
$(document).on 'page:load', ready
