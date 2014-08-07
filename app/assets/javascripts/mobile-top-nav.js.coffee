TopNav = 
	init: ->
		$('body').on 'click', '.menu-icon.left', @openNav
		$('body').on 'ajax:success', '.top-nav-content a', @closeNav
		$('.content-container').click @closeNav

	openNav: ->
		$('.top-nav-content').show().removeClass('animated fadeOutLeftBig').addClass 'animated fadeInLeftBig'
		$('.content-container').css 'background', '#414141'
		$('.content-container').css 'opacity', '.3'
		$('.content-container').css 'position', 'fixed'
		$('top-nav').css 'background', '#414141'
		$('.top-nav').css 'opacity', '.3'
		$('.top-nav-content').swipe	
			swipe: (event, direction, distance, duration, fingerCount) ->
				if direction == "left"
					TopNav.closeNav()
				threshold: 100 
		$('.mob-nav').swipe	
			swipe: (event, direction, distance, duration, fingerCount) ->
				console.log distance
				if direction == "left"
					TopNav.closeNav()
				threshold: 100 
		TopNav.state = "open"

	closeNav: ->
		$('.menu-title').text('Cliq')
		$('.menu-icon').show()
		$('.extra').remove()
		$('.top-nav-content').removeClass('animated fadeOutLeftBig').addClass('animated fadeOutLeftBig')		
		$('.chat-partial').remove()
		$('.user-other-container').remove()
		$('top-nav').css 'background', 'white'
		$('.top-nav').css 'opacity', '1'
		$('.content-container').css 'opacity', ''
		$('.content-container').css 'background', '#f1f1f1'
		$('.content-container').css 'position', 'relative'


ready = ->
	TopNav.init()
$(document).ready ready
$(document).on 'page:load', ready




