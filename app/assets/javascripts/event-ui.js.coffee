EventUi = 
	init: ->
		$('body').on 'click', '#new-open-event', @switchPane

	switchPane: ->
		$(@).toggleClass('sift-state').children().toggle()
		$('.pane.inactive').css('top', '-100%')
		$('.pane.inactive').show().animate
			top: '0'
		, 500, ->
			$(@).removeClass('inactive').addClass('current')
		
		$('.pane.current').show().animate
			top: '100%'
		, 500, ->
			$(@).removeClass('current').addClass('inactive')



ready = ->
	EventUi.init()
$(document).ready ready
$(document).on 'page:load', ready