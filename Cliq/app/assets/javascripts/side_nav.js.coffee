Animations = 
	init: ->
		$('.nav-filler').mouseover @extendSideNav
		$('#messages-container').click @revertSideNav
		$('.content-container').click @revertSideNav

	extendSideNav: ->
		$('.side-nav').hide()
		$('.extended-side-nav').show()
		$('.extended-side-nav').animate {
			width: "210px"
		}, 200
		$('.content-container').animate {
			marginLeft: "148px"
		}, 200

	revertSideNav: ->
		$('.extended-side-nav').animate {
			width: "0px"
		}, 200, ->
			$('.extended-side-nav').hide()
		
		$('.content-container').animate {
			marginLeft: "0px"
		}, 200
		
		$('.side-nav').show()










ready = ->
	Animations.init()
$(document).ready ready
$(document).on 'page:load', ready