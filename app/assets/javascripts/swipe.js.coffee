Swipe = 
	init: ->
		$('.search-form').on 'submit', @hideResults
		$('body').on 'click', '.swipe-next', @swipeNext
	
	hideResults: ->
		$('.swiped-result').hide()
		$('.swiped-result').first().show()

	swipeNext: ->
		current = $('.swiped-result:visible')
		console.log current
		next = current.next()
		current.addClass('animated slideOutRight')
		current.bind 'oanimationend animationend webkitAnimationEnd', ->
			current.hide()
			next.show()
			next.addClass ('animated slideInLeft')






ready = ->
	Swipe.init()
$(document).ready ready
$(document).on 'page:load', ready