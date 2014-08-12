Search = 
	init: ->
		@autocompleteLocations()
		@autocompleteInterests()
		$('.tab').on 'ajax:success', @autoCompleteAll
		$('body').on 'ajax:success', '.invite-user', @inviteUser
		$('body').on 'ajax:success', '.chat-user', @chatUser
		$('body').on 'ajax:beforeSend', '.chat-user', @checkTab
		$('body').on 'click', '.chat-user', @switchChat
		$('body').on 'ajax:success', '.other-user', @showUser
		$('body').on 'click', '.chat-collapse', @collapseChat if $('.mobile').length < 1
		$('body').on 'click', '.collapsed-chat', @addChat
		$('body').on 'click', '.close', @closeChat
		$('body').on 'ajax:success', '#search-form', @displayResults
		$('body').on 'ajax:success', '#search-form', @getResultInfo
		$('body').on 'submit', '#search-form', @displaySearching
		$('.content-container').click @collapseAllChat if $('.mobile').length < 1
		$('.results-container').click @collapseAllChat if $('.mobile').length < 1
		$('.send-activation').on 'submit', @thankUser
		$('body').on 'click', '.searched', @removeTerm
		$('body').on 'keypress', '#activity', @selectInterestOnEnter
		$('body').on 'click', '#cliq-invite', @inviteFriends
		$('body').on 'submit', '#friend-invite', @sendCliqInvite
		$('body').on 'keydown', '#query-location' , @deleteLocID
		

	autoCompleteAll: ->
		Search.autocompleteLocations()
		Search.autocompleteInterests()


		# @invertButtons()

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
		Search.obscureDate()
		name = $('.swiped-card-name:visible').text()
		$('.menu-title').text name
		$(".chat-partial").swipe 
			swipe: (event, direction, distance, duration, fingerCount) ->
				if direction == "right"
					$('.chat-partial').addClass 'animated fadeOutRightBig'
					$('.chat-partial').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
						$('.chat-partial').remove()
						$('.content-container').css 'opacity', ''
						$('.content-container').css 'background', '#f1f1f1'
						$('.menu-icon').show()
						$('.extra').remove()
						$('.menu-title').text 'Cliq'
			threshold: 150 
			allowPageScroll: "vertical"

	checkTab: () ->
		id = $(@).attr('href').split('/')[2]
		if $("#u-#{id}")
			$("#u-#{id}").click()
		return false if $('.messages.active').length > 0

	switchChat: ->
		if $('.conversation').length > 0
			console.log '#' + $(@).attr('href').split('/')[2]
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
		$('.chat-partial').removeClass 'current-thread'
		$(@).prev().addClass 'current-thread'
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
		if $('#activity').length > 0
			$('#activity').autocomplete(
				source: '/activities'
				select: (event, ui) ->
					event.preventDefault()
					$(@).val ui.item.label
					$('#ids').val $('#ids').val() + ui.item.value + " "
					label = ui.item.label.slice(0,25)
					if label.length > 24
						label += "..."
					$('#query-interests').prepend "<div class='query-interest search-term searched' id='#{ui.item.value}'>#{label}</div>"
					$('#activity').val('')
					$(@).css 'color', '#939393'
					$('#search-form').submit() if $('.mobile').length < 1 || $('.enable-auto-search').length > 0
				focus: (event, ui) ->
					event.preventDefault()
					$(@).val ui.item.label
					$(@).css 'color', '#414141'
					$('.ui-state-focus').removeClass('ui-state-focus').addClass 'new-focus'
				delay: 0
				open: (event, ui) -> 
					$('.ui-autocomplete').find('.ac-image').removeClass 'hidden'
					$('.ui-menu-item').each ->
			
					# 	$(@).append("<img src='/assets/#{@.value}.svg' class='ac-image'>")
					$('.ui-autocomplete').css 'width', '+=50px'

					# firstElement = $(@).data("uiAutocomplete").menu.element[0].children[0]
					# inpt = $('#activity')
					# original = inpt.val()
					# firstElementText = $(firstElement).text()
					# if firstElementText.toLowerCase().indexOf(original.toLowerCase()) == 0
					# 	inpt.val(firstElementText)
					# 	inpt[0].selectionStart = original.length; 
					# 	inpt[0].selectionEnd = firstElementText.length
				minLength: 2
				response: (event, ui) ->
			).data("uiAutocomplete")._renderItem = (ul, item) ->
				icon = $("##{item.type}").clone()
				console.log item
				console.log icon
				a = $("<li />").data("item.autocomplete", item).append("<a class='item-label'>#{item.label}</a>").appendTo(ul).prepend icon	 
				return a

        
	removeTerm: ->
		id= @.id
		ids = $('#ids')[0].value
		new_ids = ids.replace "#{id} ", ""
		$('#ids').val new_ids
		$(@).remove()


	displayResults: (event, data, xhr, status) ->
		if $('.mobile').length < 1 || $('.enable-auto-search').length > 0
			$('#search-results').html data
			$('.result').addClass 'animated fadeIn'
			$('#results').html data
			$('.swiped-result').hide()
			$('.swiped-result').first().show().addClass 'animated fadeIn'
			if $('#empty').length > 0
				$('#no-one-around').show()
			$('body').scrollTo($('.mobile .result')) if $('.searched').length < 1 && $('.mobile').length > 0


	getResultInfo: ->
		$('.result, .swiped-result').each ->
			if !$(@).hasClass('no-complete')
				id = $(@).attr('id').slice(2)
				result = $(@)
				$.get "users/#{id}/result_info", (data) ->
					result.find('.mut-stat').text data.mut
					result.find('.sim-stat').text data.sim


	displaySearching: ->
		$('#search-results').html "<div id='searching'>SEARCHING...</div>"

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

	inviteFriends: ->
		$('#pre-invite').hide()
		$('#post-invite').show()
		$('#no-one-around').css 'height', '570px'

	sendCliqInvite: ->
		@.reset()
		$('#sent-invite').show().addClass 'animated fadeIn'
		setTimeout ->
			$('#sent-invite').hide()
		, 1000

	deleteLocID: ->
		key = event.keyCode || event.charCode
		if  key == 8 || key == 46 
			$('#location_id').val ''

	obscureDate: ->
		dates = $('.date')
		Search.obscureDates dates

	obscureDates: (dates) ->
		dates.each (index) ->
			console.log @
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
	Search.init()
$(document).ready ready
$(document).on 'page:load', ready
