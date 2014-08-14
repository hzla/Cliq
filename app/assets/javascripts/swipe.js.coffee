Swipe = 
	init: ->
		$('body').on 'submit','.search-form', @hideResults
		$('body').on 'click', '.swipe-next', @swipeNext
		$('body').on 'click', '.cliq-skip', @swipeNext
		$('body').on 'ajax:success', '#friend-invite', @showKeepGoing
		@hideResults()
	
	hideResults: ->
		$('.swiped-result').first().show()
	
	showKeepGoing: ->
		$('.post').show()

	swipeNext: ->
		current = $('#results').children(':visible')
		next = current.next()
		current.addClass('animated slideOutRight')
		current.bind 'oanimationend animationend webkitAnimationEnd', ->
		current.hide()
		console.log current
		console.log next
		$('.post').hide()
		if next.attr('class') == 'swiped-result' || next.attr('id') == "empty"
			next.show()
			next.addClass ('animated slideInLeft')
		else
			$('.empty').last().show()
			$('.empty').last().find('#no-one-text').text("There seems to be no one else around. Try searching for other interests or invite your friends to join Cliq!")
			$('.empty').last().find('.cliq-skip').hide()







ready = ->
	Swipe.init()
$(document).ready ready
$(document).on 'page:load', ready