Messages = 
	init: ->
		$('.message-history')[0].scrollTop = $('.message-history')[0].scrollHeight + 100 if $('.message-history').length >= 1
		$('body')	.on 'click', '.reply', @submitMessage
		$('body').on 'click', '.convo-link', @prepConversation
		$('body').on 'ajax:success', '.convo-link', @appendConversation
		$('body').on 'keypress', '#chat-box', @submitMessageOnEnter
		$('#messages-container').parent().parent().css 'background', 'white'
		$('body').on 'ajax:success', '.block', @blockUser
		$('.conversation').hover @showBlock, @hideBlock


	showBlock: ->
		$(@).find('.convo-block').show()

	hideBlock: ->
		$(@).find('.convo-block').hide()

	submitMessage: ->
		$(@).parent().parent().prev().prev().submit()
		$('.sending-progress').text('Sending...').show() if $('#chat-box').val().replace(/^\s+|\s+$/g, "") != ""
		$('.chat-box').val ''
		

	prepConversation: ->
		$('.conversation').removeClass 'current'
		$(@).parent().addClass 'current'
		$('#messages-box').html('loading...')

	appendConversation: (event, data, xhr, status) ->
		$('#messages-box').html(data)
		$('.message-history')[0].scrollTop = $('.message-history')[0].scrollHeight
		$('.convo-link').find('.convo-last-message').each ->
			$(@).css 'color', '#bebebe' if $(@).css('color') != "rgb(24, 195, 189)"
		$(@).find('.convo-last-message').css 'color', 'white'

	submitMessageOnEnter: (e) ->
		if (e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)
			e.preventDefault()
			form = $(@).parent()
			console.log form
			form.submit()
			$('.sending-progress').text('Sending...').show() if $(@).val().replace(/^\s+|\s+$/g, "") != ""			
			$(@).val ''

	blockUser: ->
		$(@).parents('.conversation').remove()
		$('#messages-box').html ''





ready = ->
	Messages.init()
$(document).ready ready
$(document).on 'page:load', ready




