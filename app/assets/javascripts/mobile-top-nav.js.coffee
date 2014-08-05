TopNav = 
	init: ->
		$('body').on 'click', '.menu-icon.left', @openNav
		$('body').on 'ajax:success', '.top-nav-content a', @closeNav

	openNav: ->
		$('.top-nav-content').show().addClass 'animated fadeInLeftBig'
		$('.content-container').css 'background', '#414141'
		$('.content-container').css 'opacity', '.3'
		$('top-nav').css 'background', '#414141'
		$('.top-nav').css 'opacity', '.3'
		$('.top-nav-content').swipe	
				swipe: (event, direction, distance, duration, fingerCount) ->
					if direction == "left"
						$('.top-nav-content').removeClass('animated fadeInLeftBig').addClass 'animated fadeOutLeftBig'
						$('.top-nav-content').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
							TopNav.closeNav()
					threshold: 400 

	closeNav: ->
		$('.top-nav-content').hide()
		$('top-nav').css 'background', 'white'
		$('.top-nav').css 'opacity', '1'
		$('.content-container').css 'opacity', ''
		$('.content-container').css 'background', '#f1f1f1'



		









ready = ->
	TopNav.init()
$(document).ready ready
$(document).on 'page:load', ready




