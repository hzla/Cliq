Animations = 
	init: ->
		$('.extended-side-nav').hoverIntent @extendSideNav, @revertSideNav
		$('.side-icon').hoverIntent 
			over: @showLabel 
			out: @hideLabel
			sensitivity: 10000
			interval: 1 
		$('.extended-options').mouseleave @hideOptions
		$('.content-container').click @hideOptions

	hideOptions: ->
		$('.extended-options').hide().find('.icon-label').css 'opacity', '0'
		$('.extended-options').stop().animate {
			width: "62px"
		}, 200

	extendSideNav: ->
		# $('.extended-side-nav').stop().animate {
		# 	width: "210px"
		# }, 200
		# $('.extended-side-nav').css 'z-index', '1000'
		# # $('.content-container').stop().animate {
		# # 	marginLeft: "148px"
		# # }, 200
		# $('.extended-options').show()

	revertSideNav: ->
		# $('.extended-side-nav').stop().animate {
		# 	width: "62px"
		# }, 200
		# # $('.content-container').stop().animate {
		# # 	marginLeft: "0px"
		# # }, 200
		# $('.icon-label').css 'opacity', '0'
		# $('.extended-options').hide()
		


	showLabel:  (e) ->
		$(@).find('.icon-label').css 'opacity', '1'
		$(@).stop().animate {
			width: "210px"
		}, 200
		if $(e.currentTarget).attr('id') == "extended-settings"
			$('.extended-options').show().find('.icon-label').css 'opacity', '1'
			$('.extended-options').stop().animate {
				width: "210px"
			}, 200

	hideLabel: ->
		$(@).find('.icon-label').css 'opacity', '0'	
		$(@).stop().animate {
			width: "62px"
		}, 200	
		











ready = ->
	Animations.init() if $('.mobile').length < 1
$(document).ready ready
$(document).on 'page:load', ready