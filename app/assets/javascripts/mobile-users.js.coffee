MobileUsers = 
	init: ->
		$('body').on 'hover', '.mobile .act-name.other', @clickAct
		$('body').on 'click', '.settings-label', @toggleEnabled
		$('body').on 'ajax:success', '.edit_user', @showSaved
		$('body').on 'submit', '.edit_user', @showSaving

	clickAct: ->
		$(@).click()

	toggleEnabled: ->
		$(@).toggleClass("enabled")
		checkbox = $(@).prev()
		
		console.log checkbox
		console.log $(@)
		checkbox.prop("checked", !checkbox.prop("checked"))
		

		console.log checkbox.prop("checked")

	showSaved: ->
		$('#save-settings').val("Saved")
		setTimeout ->
				$('#save-settings').val("Save Settings")
			, 2000

	showSaving: ->
		$('#save-settings').val("Saving...")
			









ready = ->
	MobileUsers.init()
$(document).ready ready
$(document).on 'page:load', ready




