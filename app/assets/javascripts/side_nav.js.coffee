Animations = 
	init: ->
		$('.nav-filler').mouseover @extendSideNav
		$('.extended-side-nav').mouseleave @revertSideNav

	extendSideNav: ->
		$('.extended-side-nav').animate {
			width: "210px"
		}, 200
		$('.content-container').animate {
			marginLeft: "148px"
		}, 200
		$('.icon-label').css 'opacity', '1'

	revertSideNav: ->
		$('.extended-side-nav').animate {
			width: "62px"
		}, 200, ->
		$('.content-container').animate {
			marginLeft: "0px"
		}, 200
		$('.icon-label').css 'opacity', '0'











ready = ->
	Animations.init()
$(document).ready ready
$(document).on 'page:load', ready