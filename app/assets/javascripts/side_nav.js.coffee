Animations = 
	init: ->
		$('.extended-side-nav').hoverIntent @extendSideNav, @revertSideNav


	extendSideNav: ->
		$('.extended-side-nav').stop().animate {
			width: "210px"
		}, 200
		$('.content-container').stop().animate {
			marginLeft: "148px"
		}, 200
		$('.icon-label').css 'opacity', '1'
		$('.extended-options').show()

	revertSideNav: ->
		$('.extended-side-nav').stop().animate {
			width: "62px"
		}, 200, ->
		$('.content-container').stop().animate {
			marginLeft: "0px"
		}, 200
		$('.icon-label').css 'opacity', '0'
		$('.extended-options').hide()











ready = ->
	Animations.init()
$(document).ready ready
$(document).on 'page:load', ready