Users = 
	init: ->
		$('#got-it').on 'click', @closeWelcome

	closeWelcome: ->
		$('#activation-container').remove()



ready = ->
	Users.init()
$(document).ready ready
$(document).on 'page:load', ready