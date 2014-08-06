MobileUsers = 
	init: ->
		$('body').on 'hover', '.mobile .act-name.other', @clickAct
		$('body').on 'click', '.settings-label', @toggleEnabled
		$('body').on 'ajax:success', '.edit_user', @showSaved
		$('body').on 'submit', '.edit_user', @showSaving
		$('body').on 'click', '.scroll-cat-pic', @showScrollActs
		$('body').on 'click', '.scroll-cat-name', @showScrollActs
		$('body').on 'ajax:success', '.mobile .add-other-act', @addChosen
		$('body').on 'focus', '.mobile .profile-actions input', @tellEnter
		$('body').on 'focusout', '.mobile .profile-actions input', @revert
		$('body').on 'submit', '.mobile .profile-actions form', @focusOut

	tellEnter: ->
		MobileUsers.old = $(@).attr("placeholder")
		$(@).attr("placeholder", "submit with 'search/go' key")
		$(@).css("width", "calc(90% - 20px)")
		$('.profile-actions').find('form').hide()
		$(@).parents('form').show()

	revert: ->
		$(@).attr("placeholder", MobileUsers.old)
		$(@).css("width", "35%")
		$('.profile-actions').find('form').show()

	focusOut: ->
		$(@).find('input').trigger 'focusout'

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
		$(@).parent().find('.overlay').show()

	addChosen: -> 
		$(@).parent().toggleClass('chosen') if $('.tut').length < 1
		$(@).parent().css 'background', '#14a29d' if $('.user-other-container:visible').length > 0
			









ready = ->
	MobileUsers.init()
$(document).ready ready
$(document).on 'page:load', ready




