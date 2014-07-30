Cliq = 
	init: ->
		Cliq.nextState = true
		$('.tab').on 'ajax:success', @search
		$('.tab').on 'click', @pushState
		$(window).bind 'popstate', @popState
		@hightlightTab()

	hightlightTab: ->
		url = location.href.split('/')
		tab = url[url.length - 1]
		$("##{tab}").children('.side-icon').addClass('active')
		if url[url.length - 2] == "users"
			$('#profile').children('.side-icon').addClass('active')

	popState: -> 
    url = location.href.split('/')
    tab = url[url.length - 1]
    $("##{tab}").click()
    if url[url.length - 2] == "users"
    	$('#profile').click()
    Cliq.nextState = false
    $('.back-link').click()


		

	search: (event, data, xhr, status) ->
		$('.content-container').html data
		$('.content-container').css 'background', ''
		$('.content-container').css 'opacity', ''
		$.getScript(location.href)
		history.pushState(null, document.title, @.href) if Cliq.nextState
		Cliq.nextState = true

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