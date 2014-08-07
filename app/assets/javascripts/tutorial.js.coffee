Tutorial = 
	init: ->
		$('body').on 'click', '.char', @highlightChar
		$('body').on 'click', '.proceed', @submitTutorial
		$('body').on 'ajax:success', '.mobile .add-other-act', @updateInterestCount

	highlightChar: ->
		

		if ($('.highlighted').length < 2 && !$(@).hasClass('highlighted')) && !$(@).hasClass('char-button')
			$(@).addClass("highlighted")
		else
			$(@).removeClass("highlighted") if $(@).hasClass('highlighted')
		
		labels = []
		selected = $('.highlighted .char-label').each ->
			labels.push($(@).text())
		$('#characters').val labels

		if $('.highlighted').length == 1
			$('.char-text').text "Pick 1 more or tap next to move on"
			$('.next-tut').show()
			$('.char-button').removeClass('proceed')
		if $('.highlighted').length == 2
			$('.char-text').text "Tap to start picking interests" 
			$('.next-tut').show()
			$('.char-button').addClass('proceed')
		if $('.highlighted').length == 0
			$('.char-text').text "Pick at least 1 character"
			$('.next-tut').hide() 
			$('.char-button').removeClass('proceed')

	submitTutorial: ->
		console.log "hihihihi"
		$('#tutorial-form').submit()

	updateInterestCount: ->
		
		oldCount = $('.all-scroll-acts .chosen').length 
		$(@).parent().toggleClass('chosen')
		newCount = $('.all-scroll-acts .chosen').length 
		difference = newCount - oldCount
		intCount = parseInt($('#int-number').text())
		console.log difference
		
		if difference > 0
			intCount -= 1
		else
			intCount += 1
		$('#int-number').text(intCount)

		console.log intCount
		if intCount < 1
			$('.unfinished').hide()
			$('.finished').removeClass('animated fadeIn').show().addClass('animated fadeIn')

		if intCount > 0
			$('.unfinished').show()
			$('.finished').hide()


	




ready = ->
	Tutorial.init()
$(document).ready ready
$(document).on 'page:load', ready




