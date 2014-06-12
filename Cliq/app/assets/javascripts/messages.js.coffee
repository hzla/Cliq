Messages = 
	init: ->
		$('#message-history')[0].scrollTop = $('#message-history')[0].scrollHeight if $('#message-history').length >= 1
		$('body')	.on 'click', '.result-action.reply', @submitMessage
		$('body').on 'ajax:success', '#new_message', @appendMessage
		$('body').on 'ajax:success', '.convo-link', @appendConversation
		@selectFirstConversation()

	submitMessage: ->
		$('#new_message').submit()

	appendMessage: (event, data, xhr, status) ->
		# messages = $('#message-history')
		# messages.append data
		# $('#new_message')[0].reset()
		# $('#message-history')[0].scrollTop = $('#message-history')[0].scrollHeight
		console.log data

	appendConversation: (event, data, xhr, status) ->
		$('.conversation').removeClass 'current'
		$(@).children('.conversation').addClass('current')
		$('#messages').html(data)
		$('#message-history')[0].scrollTop = $('#message-history')[0].scrollHeight


	selectFirstConversation: ->
		$($('.conversation')[0]).addClass('current')



ready = ->
	Messages.init()
$(document).ready ready
$(document).on 'page:load', ready



