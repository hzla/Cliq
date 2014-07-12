Users = 
	init: ->
		$('#got-it').on 'click', @closeWelcome
		$('#send-feedback').on 'click', @openFeedback
		$('.content-container').on 'click', @hideFeedback
		$('#feedback-form').on 'ajax:success', @closeFeedback
		$('#feedback-form').on 'submit', @showSending

	closeWelcome: ->
		$('#activation-container').remove()

	openFeedback: -> 
		$(@).hide()
		$('#feedback').show().addClass 'animated fadeInUp'
		$('#feedback-message').hide().show().text 'Have any suggestions for Cliq? Feel free to send us some feedback!'

	hideFeedback: ->
		$('#feedback').hide()
		$('#send-feedback').show()

	closeFeedback: ->
		@.reset()
		$('#feedback-message').text('Thank you for your feedback.')

	showSending: ->
		$('#feedback-message').text('Sending...')






ready = ->
	Users.init()
$(document).ready ready
$(document).on 'page:load', ready