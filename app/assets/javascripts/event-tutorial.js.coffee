EventTutorial = 
	init: ->
		$('body').on 'click', '#sift-option', @extendSift

	extendSift: ->
		$(@).find('.option-title, .tut-sift-pic, .option-question').addClass('animated fadeOut')
		$(@).animate
			height: '100%'
			opacity: '0'
		, 500, ->
			$('#tut-container').remove()
			$('.event-form-right').addClass('animated fadeInLeft')



ready = ->
	EventTutorial.init()
$(document).ready ready
$(document).on 'page:load', ready