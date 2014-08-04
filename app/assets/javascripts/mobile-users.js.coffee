MobileUsers = 
	init: ->
		$('body').on 'hover', '.mobile .act-name.other', @clickAct

	clickAct: ->
		$(@).click()
		









ready = ->
	MobileUsers.init()
$(document).ready ready
$(document).on 'page:load', ready




