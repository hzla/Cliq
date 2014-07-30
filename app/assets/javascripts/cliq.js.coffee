Cliq = 
	init: ->
		$('.tab').on 'ajax:success', @search
		$('.tab').on 'click', @pushState

		$(window).bind 'popstate', @popstate
		$(window).bind 'pushstate', @popstate


	popState: -> 
    $.getScript location.href

		

	search: (event, data, xhr, status) ->
		
		$('.content-container').html data
		$('.content-container').css 'background', ''
		$('.content-container').css 'opacity', ''
		$.getScript(location.href)
		history.pushState(null, document.title, @.href)
		# $('.content-container').children().addClass 'animated fadeIn'
		# $(@).children().removeClass 'fadeIn'

	pushState: ->
		$('.active').removeClass 'active'
		$(@).children().addClass 'active'
		$('.content-container').css 'background', 'white'
		$('.content-container').css 'opacity', '.3'


	





ready = ->
	Cliq.init()
$(document).ready ready
$(document).on 'page:load', ready