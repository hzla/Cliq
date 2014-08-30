EventTutorial = 
	init: ->
		$('body').on 'click', '#sift-option', @extendSift
		$('body').on 'click', '#create-option', @extendcreate
		$('body').on 'click', '.confirmation.got-it', @finishTut
		$('body').on 'ajax:success', '.confirmation-form', @checkEmail
		$('body').on 'click', '#tut-1 .confirmation', @checkUCF
		$('body').on 'focus', '#email', @hidePlaceholder

	hidePlaceholder: ->
		$(@).attr('placeholder', '')

	checkUCF: ->
		if $('#email').val().slice(-7) == "ucf.edu" || $('#email').val() == "andylee.hzl@gmail.com"
			$('.confirmation-form').submit() 
		else
			$('#email').css('border', '1px solid red')
			$('#email').attr('placeholder', 'Please enter a valid UCF email')
			$('.confirmation-form')[0].reset()

	checkEmail: ->
		$(@)[0].reset()
		$('#email').attr("placeholder", "Thank you! Please check your email.")

	finishTut: ->
		$('#tut-2').hide()
		$('#tut-3').show().addClass("animated fadeIn")
		$('.tut-overlay').remove()
		$('.extended-side-nav').show()
		# console.log $(window)[0].href.replace(/\?.*=true/g, "")
		history.pushState(null, document.title, $(window)[0].location.href.replace(/\?.*=true/g, ""))

	extendcreate: ->
		$('.event-sort').first().click()
		$('#events-header-actions').show()
		$(@).find('.option-title, .tut-sift-pic, .option-question').addClass('animated fadeOut')
		create = $('.pane.inactive')
		sift = $('.pane.current')
		create.removeClass('inactive').addClass('current').animate 
			top: '0'
		, 500
		sift.css('top', '100%').addClass('inactive').removeClass('current')
		$('#event-create').show()
		$('#create-option').css('height', '100%')
		$('#create-option').animate 
			opacity: 0
		, 500
		$('#sift-option').animate 
			height: '0px'
		, 500, ->
			$('#tut-container').remove()
			$('#new-open-event').toggleClass('sift-state').children(':not(.sift-text)').toggle()
			$('#new-open-event').show().addClass('animated fadeInDown')

	extendSift: ->
		$('.event-sort').first().click()
		$('#events-header-actions').show()
		$(@).find('.option-title, .tut-sift-pic, .option-question').addClass('animated fadeOut')
		$(@).animate
			height: '100%'
			opacity: '0'
		, 500, ->
			$('#tut-container').remove()
			$('.event-form-right').addClass('animated fadeInLeft')
			$('#new-open-event').show().addClass('animated fadeInDown')



ready = ->
	EventTutorial.init()
$(document).ready ready
$(document).on 'page:load', ready