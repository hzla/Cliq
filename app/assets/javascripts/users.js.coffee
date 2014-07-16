Users = 
	init: ->
		$('#got-it').on 'click', @closeWelcome
		$('#send-feedback').on 'click', @openFeedback
		$('.content-container').on 'click', @hideFeedback
		$('#faq-container').on 'click', @hideFeedback
		$('#feedback-form').on 'ajax:success', @closeFeedback
		$('#feedback-form').on 'submit', @showSending
		$('.edit_user').on 'ajax:success', @showSettingsStatus
		$('#delete-account').on 'click', @showDeleteModal
		$('#cancel-delete').on 'click', @cancelDelete
		$('body').on 'mouseenter', '.act-name.other', @showPlus
		$('body').on 'mouseleave', '.act-name.other', @showDot
		$('body').on 'ajax:success', '.add-other-act', @addAct

	closeWelcome: ->
		$('#activation-container').remove()

	openFeedback: -> 
		$(@).hide()
		console.log "show"
		$('#feedback').show().addClass 'animated fadeInUp'
		$('#feedback-message').hide().show().text 'Have any suggestions for Cliq? Feel free to send us some feedback!'

	hideFeedback: ->
		$('#feedback').hide()
		$('#send-feedback').show()

	closeFeedback: ->
		@.reset()


	showSending: ->
		@.reset()
		$('#feedback-message').text('Thank you for your feedback.')

	showSettingsStatus: (event, data, xhr, status) ->
		console.log data
		if data.error 
			console.log "Error"
			$('#user_address').css 'border', '2px solid #ff5959'
		else
			console.log "did this"
			$('#faq-questions').append "<div id='settings-success'>Successfully updated.</div>"
			$('#settings-success').show().addClass 'animated fadeIn'
			$('#user_address').css 'border', 'none'
			setTimeout ->
				$('#settings-success').remove()
			, 3000

	showDeleteModal: ->
		$('#delete-modal').modal()

	cancelDelete: -> 
		$.modal.close()

	showPlus: ->
		if !$(@).hasClass('shared')
			newText = $(@).text().replace('•', '+')
			$(@).text newText
	showDot: ->
		newText = $(@).text().replace('+', '•')
		$(@).text newText

	addAct: ->
		console.log @
		$(@).find('.act-name').addClass('orange shared').removeClass('different')






ready = ->
	Users.init()
$(document).ready ready
$(document).on 'page:load', ready