Search = 
	init: ->
		$('body').on 'ajax:success', '.invite-user', @inviteUser
		$('body').on 'ajax:success', '.chat-user', @chatUser
		$('body').on 'click', '.chat-collapse', @collapseChat
		$('body').on 'click', '.collapsed-chat', @addChat

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

ready = ->
	Search.init()
$(document).ready ready
$(document).on 'page:load', ready
