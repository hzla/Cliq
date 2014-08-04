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

	closeNav: ->
		$('.top-nav-content').hide()
		$('top-nav').css 'background', 'white'
		$('.top-nav').css 'opacity', '1'


		









ready = ->
	TopNav.init()
$(document).ready ready
$(document).on 'page:load', ready




