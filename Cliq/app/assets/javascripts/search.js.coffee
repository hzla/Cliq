Search = 
	init: ->
		@autocompleteLocations()
		@autocompleteInterests()
		$('body').on 'ajax:success', '.invite-user', @inviteUser
		$('body').on 'ajax:success', '.chat-user', @chatUser
		$('body').on 'click', '.chat-collapse', @collapseChat
		$('body').on 'click', '.collapsed-chat', @addChat
		$('body').on 'ajax:success', '#search-form', @displayResults

	inviteUser: (event, data, xhr, status) ->
		$('#invite-modal-container').html data
		$('#invite-modal-container').modal()
		$('#invite-modal-container').addClass "animated bounceInUp"

	chatUser: (event, data, xhr, status) ->
		$('body').append data
		$('.chat-partial').last().addClass 'animated bounceInRight'

	collapseChat: ->
		$(@).parents('.chat-partial').addClass 'bounceOutRight'
		collapsed = $(@).parents('.chat-partial').next()
		collapsedCount = $('.collapsed-chat').length 
		className = collapsed[0].className
		console.log collapsed
		if !collapsed.hasClass('indented')
			console.log "reindented"
			indent = true
		
		collapsed.removeClass()
		if indent == true
			collapsed.addClass "indented indent-" + collapsedCount
		console.log collapsed
		collapsed.show().addClass(className + " animated bounceInLeft").show()
		collapsedCount = $('.collapsed-chat').length - 1

	addChat: ->
		$(@).addClass 'animated bounceOutLeft'
		$(@).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(@).removeClass 'animated bounceInLeft bounceOutLeft'
			$(@).hide()	
		$(@).prev().removeClass().addClass 'chat-partial animated bounceInRight'

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
		$('#results').html(data)



ready = ->
	Search.init()
$(document).ready ready
$(document).on 'page:load', ready
