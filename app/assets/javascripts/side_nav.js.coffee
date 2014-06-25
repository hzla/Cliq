Animations = 
	init: ->
		$('.nav-filler').mouseover @extendSideNav
		$('#messages-container').click @revertSideNav
		$('.extended-side-nav').mouseleave @revertSideNav

	extendSideNav: ->
		$('.side-nav').hide()
		$('.extended-side-nav').show()
		$('.extended-side-nav').animate {
			width: "210px"
		}, 200
		$('.content-container').animate {
			marginLeft: "148px"
		}, 200
		show = () ->
			$('.icon-label').show()
			$('.icon-label').addClass('animated bounceInLeft')
		setTimeout show, 60
		$('.extended .nav-icon').css 'float', 'left'
		$('.nav-filler').hide()

	revertSideNav: ->
		$('.extended-side-nav').animate {
			width: "62px"
		}, 200, ->
		$('.icon-label').hide()
		$('#cliq-logo').show()
		$('.extended .nav-icon').css 'float', 'none'
		$('.content-container').animate {
			marginLeft: "0px"
		}, 200
		$('.nav-filler').show()











ready = ->
	Animations.init()
$(document).ready ready
$(document).on 'page:load', ready