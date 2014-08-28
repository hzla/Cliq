Users = 
	init: ->
		$('body').on 'click', '#got-it', @closeWelcome
		$('#send-feedback').on 'click', @openFeedback
		$('.content-container').on 'click', @hideFeedback
		$('#faq-container').on 'click', @hideFeedback
		$('#feedback-form').on 'ajax:success', @closeFeedback
		$('#feedback-form').on 'submit', @showSending
		$('body').on 'ajax:success', '.edit_user', @showSettingsStatus
		$('body').on 'click', '#delete-account', @showDeleteModal
		$('body').on 'click', '#cancel-delete', @cancelDelete
		$('body').on 'mouseenter', '.act-name.other', @showPlus if $('.mobile').length < 1
		$('body').on 'mouseleave', '.act-name.other', @showDot if $('.mobile').length < 1
		$('body').on 'ajax:success', '.add-other-act', @addAct
		$('body').on 'click', '.shared-ints', @showShared
		$('body').on 'click', '.different-ints', @showDifferent
		$('body').on 'click', '.all-ints', @showAll
		$('body').on 'click', '#quick-add' , @prepQuickAdd
		$('body').on 'submit', '#quick-search', @addInterest

	addInterest: ->
		id = "#c-" + $('.interest-info').text().split("@")[0]
		if $(id).length > 0
			$(id).append "<div class='activity'><div class='act-name'>#{$('#self-search').val()} •</div></div>"
		else
			root_id = "#c-" + $('.interest-info').text().split("@")[1]

			catName = $('.interest-info').text().split("@")[2]
			$(root_id).append "<div class='cat-group-self'><div class='category dark-gray'><div class='cat-name'>#{catName}</div>
			</div><div class='activities' id='#{id}'><div class='act-name'>#{$('#self-search').val()} •</div></div></div>"

	closeWelcome: ->
		console.log "asdf"
		if $('#email').val().slice(-7) == "ucf.edu"
			$('.welcome-form').submit()
			$('#activation-container').hide()
		else
			$('#email').css('border', '1px solid red')


	openFeedback: -> 
		$(@).hide()
		$('#feedback').show().addClass 'animated fadeInUp'


	hideFeedback: ->
		$('#feedback').hide()
		$('#send-feedback').show()

	closeFeedback: ->
		@.reset()


	showSending: ->
		@.reset()
		$('#feedback-message').text('Thank you for your feedback.')

	showSettingsStatus: (event, data, xhr, status) ->
		if data.error 
			console.log "Error"
			$('#user_address').css 'border', '2px solid #ff5959'
		else
			$('#faq-questions').append "<div id='settings-success'>Successfully updated.</div>" if $('.mobile').length < 1
			$('#settings-success').show().addClass 'animated fadeIn'
			$('#user_address').css 'border', 'none'
			setTimeout ->
				$('#settings-success').remove()
			, 2000

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
		$(@).find('.act-name').addClass('orange shared').removeClass('different')

	showShared: ->
		$('.int-type').removeClass 'selected'
		$(@).addClass 'selected'
		$('.act-name.different').parent().hide()
		$('.act-name.shared').parent().show()
		$('.cat-group').show()
		$('.cat-group').children('.activities').each ->
			if $(@).find('.act-name:visible').length < 1
				$(@).parent().hide()

	showDifferent: ->
		$('.int-type').removeClass 'selected'
		$(@).addClass 'selected'
		$('.act-name.different').parent().show()
		$('.act-name.shared').parent().hide()
		$('.cat-group').show()
		$('.cat-group').children('.activities').each ->
			if $(@).find('.act-name:visible').length < 1
				$(@).parent().hide()

	showAll: ->
		$('.int-type').removeClass 'selected'
		$(@).addClass 'selected'
		$('.activity').show()
		$('.cat-group').show()

	prepQuickAdd: ->
		$(@).hide()
		$('#quick-search').show()
		$('#new_activity').css 'margin-top', '195px'

ready = ->
	Users.init()
$(document).ready ready
$(document).on 'page:load', ready