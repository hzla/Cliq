Messages = 
	init: ->
		$('#message-history')[0].scrollTop = $('#message-history')[0].scrollHeight + 100 if $('#message-history').length >= 1
		$('body')	.on 'click', '.result-action.reply', @submitMessage
		$('body').on 'ajax:success', '.convo-link', @appendConversation
		$('body').on 'keypress', '#chat-box', @submitMessageOnEnter
		@selectFirstConversation()

	submitMessage: ->
		$('#new_message').submit()

	appendConversation: (event, data, xhr, status) ->
		$('.conversation').removeClass 'current'
		$(@).children('.conversation').addClass('current')
		$('#messages').html(data)
		$('#message-history')[0].scrollTop = $('#message-history')[0].scrollHeight

	selectFirstConversation: ->
		$($('.conversation')[0]).addClass('current')

	submitMessageOnEnter: (e) ->
		if (e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)
			$('#new_message').submit()




ready = ->
	Messages.init()
$(document).ready ready
$(document).on 'page:load', ready




