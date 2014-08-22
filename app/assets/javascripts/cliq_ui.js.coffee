CliqUi = 
	init: ->
		$('body').on 'ajax:success', '.invite-user', @inviteUser
		$('body').on 'ajax:beforeSend', '.chat-user', @checkTab
		$('body').on 'click', '.chat-user', @switchChat
		$('body').on 'ajax:success', '.chat-user', @chatUser
		$('body').on 'ajax:success', '.other-user', @showUser
		$('body').on 'click', '.chat-collapse', @collapseChat if $('.mobile').length < 1
		$('body').on 'click', '.collapsed-chat', @addChat
		$('body').on 'click', '.close', @closeChat
		$('.content-container').click @collapseAllChat if $('.mobile').length < 1
		$('.results-container').click @collapseAllChat if $('.mobile').length < 1
		$('body').on 'ajax:success', '.mobile .event-action', @closeEvent
		@bounceFeedback()

	bounceFeedback: ->
		setTimeout ->
			setInterval ->
				$('#send-feedback').css 'background', '#414141'
				$('#send-feedback').hide().hide().show()
			, 30000
		, 30000

	closeEvent: ->
		id = $(@).attr('id')
		joined = $(@).hasClass('join')
		CliqUi.swipeAway()
		if joined
			$("##{id}").show()
			$("##{id}").parents('.conversation').addClass('joined')
		else
			$("##{id}").parents('.conversation').hide()
		
	inviteUser: (event, data, xhr, status) ->
		$('#invite-modal-container').html data
		$('#invite-modal-container').modal()
		$('#invite-modal-container').addClass "animated bounceInUp"
		$('.content-container').css 'opacity', ''

	chatUser: (event, data, xhr, status) ->
		event.preventDefault()
		if $('.user-other-container').length < 1
			$('.content-container').css 'background', 'white'
			$('.content-container').css 'opacity', '.3'
		if $('#' + $(@).attr('href').split('/')[2]).length < 1
			$('body').append data
			$('.chat-partial').removeClass('current-thread')
			$('.chat-partial').last().addClass 'animated bounceInRight current-thread'
			$('.chat-partial').addClass('mobile') if $('.mobile').length > 0
		$('.mobile .message-history').kinetic
			x: false
		CliqUi.obscureDate() if !$(@).hasClass('no-obscure')
		$(@).find('.new-tag').hide()
		name = $('.swiped-card-name:visible').text()
		$('.menu-title').text name
		$(".chat-partial").swipe 
			swipe: (event, direction, distance, duration, fingerCount) ->
				if direction == "right"
					CliqUi.swipeAway()
			threshold: 150 
			allowPageScroll: "vertical"

	swipeAway: ->
		$('.chat-partial').addClass 'animated fadeOutRightBig'
		$('.chat-partial').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$('.chat-partial').remove()
			$('.content-container').css 'opacity', ''
			$('.content-container').css 'background', '#f1f1f1'
			$('.menu-icon').show()
			$('.extra').remove()
			$('.back-tut').hide()
			$('.menu-title').text 'Cliq'		

	checkTab: () ->
		id = $(@).attr('href').split('/')[2]
		if $("#u-#{id}")
			$("#u-#{id}").click()
		return false if $('.messages.active').length > 0

	switchChat: ->
		if $('.conversation').length > 0
			$('.user-other-container').remove()
			$('#' + $(@).attr('href').split('/')[2]).children('.convo-link').click()
			$('.content-container').css 'opacity', ''
			$('.content-container').css 'background', '#f1f1f1'

	showUser: (event, data, xhr, status) ->
			$('.user-other-container').remove()
			$('body').append data
			$('.user-other-container').addClass 'animated bounceInRight'
			$('.content-container').css 'opacity', '.3'
			$('.cat-collection').kinetic()
			$('#profile-container').swipe	
				swipe: (event, direction, distance, duration, fingerCount) ->
					if direction == "right"
						$('.user-other-container').addClass 'animated fadeOutRightBig'
						$('.user-other-container').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
							$('.chat-partial').remove()
							$('.content-container').css 'opacity', ''
							$('.content-container').css 'background', '#f1f1f1'
							$('.menu-title').text 'Cliq'
							$('.menu-icon').show()
							$('.extra').hide()
					threshold: 150 
					allowPageScroll: "vertical"
				

	collapseChat: ->
		CliqUi.collapse $(@).parents('.chat-partial')

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
			CliqUi.collapse $(@) if $('#chat-partial-content')
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
		$('.chat-partial').removeClass 'current-thread'
		$(@).prev().addClass 'current-thread'
		if $('.chat-partial').length > 0
			$('.content-container').css 'background', 'white'
			$('.content-container').css 'opacity', '.3'
        
	closeChat: -> 
		$(@).parent().parent().prev().remove()
		$(@).parent().parent().remove()
		$('.content-container').css 'opacity', ''
		$('.content-container').css 'background', '#f1f1f1'

	obscureDate: ->
		if $('.no-obscure').length < 1
			dates = $('.date')
			CliqUi.obscureDates dates
		$('.date:visible').parents('.message-block').addClass('new')

	obscureDates: (dates) ->
		dates.each (index) ->
			if dates[index - 1] == undefined
				return
			else 
				date = $(dates[index - 1]).text()
				time = date.substr(date.length - 9).trim().slice(0,4)
				hours = parseInt(time.slice(0,1)) * 60
				mins = parseInt(time.slice(2,4))
				totalTime = hours + mins
				cTime = $(@).text().substr(date.length - 9).trim().slice(0,4)
				cHours = parseInt(cTime.slice(0,1)) * 60
				cMins = parseInt(cTime.slice(2,4))
				cTotalTime = cHours + cMins
				difference = cTotalTime - totalTime
				if difference < 30 && difference > -1
					$(@).hide() 

ready = ->
	CliqUi.init()
$(document).ready ready
$(document).on 'page:load', ready
