MobileEvents = 
	init: ->
		$('body').on 'ajax:success', '.event-bar-link', @showEvents
		$('body').on 'ajax:success', '.public-event-create', @showEventForm
		$('body').on 'ajax:success', '#new_event', @closeForm
		$('body').on 'ajax:success', '.public-event-create, #event-list .chat-user', @showBack
		$('body').on 'touchend', '.event-back', @closeEventModals
		$('body').on 'click', '.filter-link', @showFilters
		$('body').on 'click', '.filter-button', @liftFilter

	liftFilter: ->
		$('.filter-container').removeClass('animated bounceInDown').addClass('animated bounceOutUp')
		$('.filter-container').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(@).hide()

	showFilters: ->
		$('.filter-container').show().removeClass('animated bounceOutUp').addClass('animated bounceInDown')

	closeEventModals: ->
		$('.message-content').show()
		$('.chat-partial').remove()
		$('#event-form').remove()
		$('.back-tut').hide()
		$('.menu-title').text("Cliq")
		setTimeout ->
			$('.menu-icon').show()
		, 750
		
		$('.content-container').css 
			opacity: ''
			background: '#f1f1f1'

	showBack: ->
		$('.back-tut').show()
		$('.menu-icon.left').hide()

	closeForm: (event, data, xhr, status) ->
		if data.ok == true
			$.modal.close()
			$('#event-form').addClass('animated bounceOutUp')
			$('#event-form').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
				$(@).remove()
				$('.event-bar-link').first().click()
			('.message-content').show()

	showEventForm: (event, data, xhr, status) ->
		$('.content-container').append 	"<div id='event-form'></div>"
		$('.message-content').hide()
		$('#event-form').html(data).addClass 'animated bounceInDown'


	showEvents: (event, data, xhr, status) ->
		$('#event-list').html(data)
		$('.conversation').addClass('animated fadeIn')
		MobileEvents.closeEventModals();








ready = ->
	MobileEvents.init()
$(document).ready ready
$(document).on 'page:load', ready




