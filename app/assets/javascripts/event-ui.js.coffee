EventUi = 
	init: ->
		$('body').on 'click', '#new-open-event', @switchPane
		$('body').on 'click', '#next-form', @nextForm
	
	nextForm: ->
		title = $('#event_title').val() != ""
		starttime = $('#event_start_time').val() != ""
		
		if title && starttime
			$('#form-section-1').addClass('animated fadeOutLeft')
			$('#form-section-2').show().addClass('animated fadeInRight')
		else
			$('#event_title').css('border', '1px solid red') if !title
			$('#event_start_time').css('border', '1px solid red') if !starttime

	switchPane: ->
		$(@).toggleClass('sift-state').children(':not(.sift-text)').toggle()
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