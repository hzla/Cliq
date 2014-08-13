MobileMessages = 
	init: ->
		$('body').on 'click', '.mobile .convo-link', @swipeToConvo
		$('body').on 'ajax:success', '.mobile .convo-link', @appendConvo
		$('body').on 'ajax:success', '#new_message', @obscurelastDates
		$('body').on 'ajax:success', '.chat-user', @obscureDate
		$('body')	.on 'click', '.mobile .reply', @submitMessage
		$('body').on 'click', '.mobile .content-container', @removeChat
		$('body').on 'click', '.mobile .results-container', @removeChat
		$('body').on 'touchend', '.back-tut.close-chat', @removeChat  
		$('body').on 'ajax:success', '.convo-link', @obscureDate

	removeChat: ->
		$('.chat-partial').remove()
		$('.content-container').css 'opacity', ''
		$('.content-container').css 'background', '#f1f1f1'
		setTimeout ->
			$('.menu-icon').show()
		, 400
		$('.menu-title').text 'Cliq'
		$('.close-chat').remove()


	submitMessage: ->
		$('#new_message').submit()
		$('#new_message')[0].reset()
		$('.message-history')[0].scrollTop = 0
		$('.message-history')[0].scrollTop = $('.message-history')[0].scrollHeight 

	clickConvoLink: ->
		$(@).find('.convo-link').click()

	swipeToConvo: ->
		$('.message-content').removeClass().addClass('animated fadeOutLeftBig message-content')
		$('#thread-container').removeClass().addClass('animated fadeInRightBig')

	swipeToMessages: ->
		$('.message-content').removeClass('animated fadeOutLeftBig').addClass('animated fadeInLeftBig')
		$('#thread-container').removeClass().addClass('animated fadeOutRightBig')
		$('.menu-title').text "Cliq"

	appendConvo: (event, data, xhr, status) ->
		pic = $(@).prev().find('.convo-pic').clone()
		$('.menu-title').html pic
		$('.top-nav .convo-pic').addClass('top-pic')
		$('#messages-box').html(data)
		$('.message-history')[0].scrollTop = $('.message-history')[0].scrollHeight
		$('.message-history').kinetic();
		$('.convo-link').find('.convo-last-message').each ->
			$(@).css 'color', '#bebebe' if $(@).css('color') != "rgb(24, 195, 189)"
		$(@).find('.convo-last-message').css 'color', 'white'
		MobileMessages.obscureDates $('.date')
		$("#messages-box").swipe 
  		swipe: (event, direction, distance, duration, fingerCount) ->
    		MobileMessages.swipeToMessages() if direction == "right"
    	threshold: 150 
    	allowPageScroll: "vertical"

	obscurelastDates: ->
		dates = $('.date')
		lastDates = dates.slice( dates.length - 2, dates.length)
		MobileMessages.obscureDates lastDates
		$('.date:visible').parents('.message-block').addClass('new')

	obscureDate: ->
		dates = $('.date')
		lastDates = dates.slice( dates.length - 2, dates.length)
		MobileMessages.obscureDates dates
		
	

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
	MobileMessages.init()
$(document).ready ready
$(document).on 'page:load', ready




