Messages = 
	init: ->
		$('.message-history')[0].scrollTop = $('.message-history')[0].scrollHeight + 100 if $('.message-history').length >= 1
		$('body')	.on 'click', '.reply', @submitMessage
		$('body').on 'click', '.convo-link', @prepConversation
		$('body').on 'ajax:success', '.convo-link', @appendConversation
		$('body').on 'keypress', '#chat-box', @submitMessageOnEnter
		$('#messages-container').parent().parent().css 'background', 'white'
		@selectFirstConversation()

	submitMessage: ->
		$('#new_message').submit()
		$('.sending-progress').text('Sending...').show() if $('#chat-box').val().replace(/^\s+|\s+$/g, "") != ""
		$('#chat-box').val ''
		

	prepConversation: ->
		$('.conversation').removeClass 'current'
		$(@).parent().addClass 'current'
		$('#messages').html('loading...')

	appendConversation: (event, data, xhr, status) ->
		$('#messages').html(data)
		$('.message-history')[0].scrollTop = $('.message-history')[0].scrollHeight
		$('.convo-link').find('.convo-last-message').each ->
			$(@).css 'color', '#bebebe' if $(@).css('color') != "rgb(24, 195, 189)"
		$(@).find('.convo-last-message').css 'color', 'white'

	selectFirstConversation: ->
		$($('.conversation')[0]).addClass('current')

	submitMessageOnEnter: (e) ->
		if (e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)
			e.preventDefault()
			Messages.submitMessage()
			$('#chat-box').val ''
			$('#new_message')[0].reset()




ready = ->
	Messages.init()
$(document).ready ready
$(document).on 'page:load', ready




