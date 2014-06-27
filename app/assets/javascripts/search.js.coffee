Search = 
	init: ->
		@autocompleteLocations()
		@autocompleteInterests()
		$('body').on 'ajax:success', '.invite-user', @inviteUser
		$('body').on 'ajax:success', '.chat-user', @chatUser
		$('body').on 'click', '.chat-collapse', @collapseChat
		$('body').on 'click', '.collapsed-chat', @addChat
		$('body').on 'click', '.close', @closeChat
		$('body').on 'ajax:success', '#search-form', @displayResults
		$('.content-container').click @collapseAllChat
		$('.send-activation').on 'submit', @thankUser
		@invertButtons()

	inviteUser: (event, data, xhr, status) ->
		$('#invite-modal-container').html data
		$('#invite-modal-container').modal()
		$('#invite-modal-container').addClass "animated bounceInUp"

	chatUser: (event, data, xhr, status) ->
		event.preventDefault()
		if $('#' + $(@).attr('href').split('/')[2]).length < 1
			$('body').append data
			$('.chat-partial').last().addClass 'animated bounceInRight'

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

	collapseAllChat: ->
		$('div.chat-partial').not('.bounceOutRight').each () ->
			Search.collapse $(@)


	addChat: ->
		$(@).addClass 'animated bounceOutLeft'
		$(@).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(@).removeClass 'animated bounceInLeft bounceOutLeft shown'
			$(@).hide()	
		$(@).prev().removeClass().addClass 'chat-partial animated bounceInRight'
		$('.chat-partial').css 'z-index', '2'
		$(@).prev().css 'z-index', '3'

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
				$(this).val ui.item.label
				$('#ids').val $('#ids').val() + ui.item.value + " "
				$('#query-interests').prepend "<div class='query-interest search-term'>#{ui.item.label}</div>"
				$('#activity').val('')
			focus: (event, ui) ->
				event.preventDefault()
				$(this).val ui.item.label
			delay: 0

	displayResults: (event, data, xhr, status) ->
		$('#results').html data
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
		$(@).remove()

	thankUser: (event, data, xhr, status) ->
		$(@).hide()
		$('#thank-you').show().addClass 'animated fadeIn'



ready = ->
	Search.init()
$(document).ready ready
$(document).on 'page:load', ready