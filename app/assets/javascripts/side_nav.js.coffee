Animations = 
	init: ->
		$('.side-icon#extended-settings').hoverIntent 
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

	showLabel:  (e) ->
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