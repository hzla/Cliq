MobileUsers = 
	init: ->
		$('body').on 'hover', '.mobile .act-name.other', @clickAct
		$('body').on 'click', '.settings-label', @toggleEnabled
		$('body').on 'ajax:success', '.edit_user', @showSaved
		$('body').on 'submit', '.edit_user', @showSaving
		$('body').on 'click', '.scroll-cat-pic', @showScrollActs
		$('body').on 'click', '.scroll-cat-name', @showScrollActs

	clickAct: ->
		$(@).click()

	toggleEnabled: ->
		$(@).toggleClass("enabled")
		checkbox = $(@).prev()
		checkbox.prop("checked", !checkbox.prop("checked"))

	showSaved: ->
		$('#save-settings').val("Saved")
		setTimeout ->
				$('#save-settings').val("Save Settings")
			, 2000

	showSaving: ->
		$('#save-settings').val("Saving...")

	showScrollActs: ->
		acts = $(@).parent().next().children().clone()
		index =  $('.scroll-cat').index($(@).parent()) - 1
		$('.overlay').hide()
		$('.cat-collection').scrollLeft (index * 125) + 20
		$('.all-scroll-acts').html acts
		$('.all-scroll-acts').prepend $('.all-scroll-acts .chosen')
		$(@).next().show()
			









ready = ->
	MobileUsers.init()
$(document).ready ready
$(document).on 'page:load', ready




