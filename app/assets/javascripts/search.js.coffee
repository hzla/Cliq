Search = 
	init: ->
		@autocompleteLocations()
		@autocompleteInterests()
		$('body').on 'ajax:success', '.invite-user', @inviteUser
		$('body').on 'ajax:success', '.chat-user', @chatUser
		$('body').on 'ajax:beforeSend', '.chat-user', @checkTab
		$('body').on 'click', '.chat-user', @switchChat
		$('body').on 'ajax:success', '.other-user', @showUser
		$('body').on 'click', '.chat-collapse', @collapseChat
		$('body').on 'click', '.collapsed-chat', @addChat
		$('body').on 'click', '.close', @closeChat
		$('body').on 'ajax:success', '#search-form', @displayResults
		$('.content-container').click @collapseAllChat
		$('.results-container').click @collapseAllChat
		$('.send-activation').on 'submit', @thankUser
		$('body').on 'click', '.searched', @removeTerm
		$('body').on 'keypress', '#activity', @selectInterestOnEnter

		# @invertButtons()

	inviteUser: (event, data, xhr, status) ->
		$('#invite-modal-container').html data
		$('#invite-modal-container').modal()
		$('#invite-modal-container').addClass "animated bounceInUp"

	chatUser: (event, data, xhr, status) ->
		event.preventDefault()
		$('.content-container').css 'background', 'white'
		$('.content-container').css 'opacity', '.3'
		if $('#' + $(@).attr('href').split('/')[2]).length < 1
			$('body').append data
			$('.chat-partial').last().addClass 'animated bounceInRight'

	checkTab: () ->
		console.log "checked"
		return false if $('.messages.active').length > 0

	switchChat: ->
		if $('.messages.active').length > 0
			console.log '#' + $(@).attr('href').split('/')[2]
			$('.user-other-container').remove()
			$('#' + $(@).attr('href').split('/')[2]).children('.convo-link').click()
			$('.content-container').css 'opacity', ''
			$('.content-container').css 'background', '#f1f1f1'


	showUser: (event, data, xhr, status) ->
			$('.user-other-container').remove()
			$('body').append data
			$('.user-other-container').addClass 'animated bounceInRight'
			$('.content-container').css 'background', 'white'
			$('.content-container').css 'opacity', '.3'

	collapseChat: ->
		Search.collapse $(@).parents('.chat-partial')


	collapse: (chat) ->
		chat.addClass 'bounceOutRight'
		collapsed = chat.next()
		collapsedCount = $('.collapsed-chat.shown').length + 1
		className = collapsed[0].className
		if !collapsed.hasClass('indented')
			indent = true
		
		collapsed.removeClass()
		if indent == true
			collapsed.addClass " shown indented indent-" + collapsedCount
		collapsed.show().addClass(className + " animated bounceInLeft").show()
		collapsedCount = $('.collapsed-chat').length - 1
		$('.content-container').css 'opacity', ''
		$('.content-container').css 'background', '#f1f1f1'

	collapseAllChat: ->
		$('div.chat-partial').not('.bounceOutRight').each () ->
			Search.collapse $(@) if $('#chat-partial-content')
		$('.user-other-container').hide()
		$('.content-container').css 'opacity', ''
		$('.content-container').css 'background', '#f1f1f1'

	addChat: ->
		$(@).addClass 'animated bounceOutLeft'
		$(@).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(@).removeClass 'animated bounceInLeft bounceOutLeft shown'
			$(@).hide()	
		$(@).prev().removeClass().addClass 'chat-partial animated bounceInRight'
		$('.chat-partial').css 'z-index', '2'
		$(@).prev().css 'z-index', '3'
		console.log "happened"
		if $('.chat-partial').length > 0
			$('.content-container').css 'background', 'white'
			$('.content-container').css 'opacity', '.3'

	autocompleteLocations: ->
		$('#query-location').autocomplete
			source: '/locations'
			select: (event, ui) ->
				event.preventDefault()
				$(this).val ui.item.label
				$('#location_id').val ui.item.value
			focus: (event, ui) ->
				event.preventDefault()
				$(this).val ui.item.label
	
	autocompleteInterests: ->
		$('#activity').autocomplete
			source: '/activities'
			select: (event, ui) ->
				event.preventDefault()
				$(@).val ui.item.label
				$('#ids').val $('#ids').val() + ui.item.value + " "
				$('#query-interests').prepend "<div class='query-interest search-term searched' id='#{ui.item.value}'>#{ui.item.label}</div>"
				$('#activity').val('')
				$(@).css 'color', '#939393'
				$('#search-form').submit()
			focus: (event, ui) ->
				event.preventDefault()
				$(@).val ui.item.label
				$(@).css 'color', '#414141'
			delay: 0
			# open: (event, ui) -> 
			# 	firstElement = $(@).data("uiAutocomplete").menu.element[0].children[0]
			# 	inpt = $('#activity')
			# 	original = inpt.val()
			# 	firstElementText = $(firstElement).text()
			# 	if firstElementText.toLowerCase().indexOf(original.toLowerCase()) == 0
			# 		inpt.val(firstElementText)
			# 		inpt[0].selectionStart = original.length; 
			# 		inpt[0].selectionEnd = firstElementText.length
			minLength: 2
        
	removeTerm: ->
		id= @.id
		ids = $('#ids')[0].value
		new_ids = ids.replace "#{id} ", ""
		$('#ids').val new_ids
		$(@).remove()


	displayResults: (event, data, xhr, status) ->
		$('#results').html data
		$('.swiped-result').hide()
		$('.swiped-result').first().show()
		$('#found').text "Here's who we found:"
		$('#found').text "Sorry, we couldn't find anyone." if $('#empty').length > 0
		$('#found').text "Please enter a valid location." if $('#invalid').length > 0

	invertButtons: ->
		$('.inv-btn').mouseenter ->
			color = $(@).find('.result-action').css 'color'
			background = $(@).css 'background-color'
			$(@).css 'height', '-=2px'
			$(@).css 'background-color', color
			$(@).find('.result-action').css 'color', background
			$(@).css 'border', "1px solid #{background}"
			$(@).find('.action-icon').css 'background-color', background
			$(@).find('.action-icon').css 'border', "1px solid #{background}"
		$('.inv-btn').mouseleave ->
			color = $(@).find('.result-action').css 'color'
			background = $(@).css 'background-color'
			$(@).css 'height', '+=2px'
			$(@).css 'background-color', color
			$(@).find('.result-action').css 'color', background
			$(@).css 'border', "none"
			$(@).find('.action-icon').css 'background-color', 'none'
			$(@).find('.action-icon').css 'border', 'none'

	closeChat: -> 
		$(@).parent().parent().prev().remove()
		$(@).parent().parent().remove()
		$('.content-container').css 'opacity', ''
		$('.content-container').css 'background', '#f1f1f1'

	thankUser: (event, data, xhr, status) ->
		if $('#email').val().match(/.+@.+\..+/i) != null
			$('#top').html ""
			$('#top').html "<div id='ty'>Thank you for signing up. Please check your email and<br> refresh the page when you've been activated</div>" 
			$('#top').css 'right', '60px'
			$('#ty').addClass 'animated fadeIn'
		else
			$('#top').html ""
			$('#top').html "<div id='ty'>Please enter a valid email to sign up</div>" 
			$('#top').css 'right', '152px'
			$('#ty').addClass 'animated fadeIn'

	selectInterestOnEnter: (e) ->
		if (e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)
			$('.ui-menu-item:visible').first().click()





ready = ->
	Search.init()
$(document).ready ready
$(document).on 'page:load', ready
