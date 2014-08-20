MobileUsers = 
	init: ->
		$('body').on 'hover', '.mobile .act-name.other', @clickAct
		$('body').on 'click', '.settings-label', @toggleEnabled
		$('body').on 'ajax:success', '.edit_user', @showSaved
		$('body').on 'submit', '.edit_user', @showSaving
		$('body').on 'touchstart', '.overlay', @showScrollActs
		$('body').on 'touchstart', '.scroll-cat-name', @showScrollActs
		$('body').on 'ajax:success', '.mobile .add-other-act', @addChosen
		$('body').on 'focus', '.mobile .profile-actions input', @tellEnter
		$('body').on 'focusout', '.mobile .profile-actions input', @revert
		$('body').on 'submit', '.mobile .profile-actions form', @focusOut
		$('body').on 'click', '#save-settings-button', @submitSettings
		$('body').on 'scroll', '.all-scroll-acts', @scrollDown
		$('body').on 'ajax:success', '.profile-actions form, #cat-header-content form', @feedback

	feedback: ->
		console.log "tried"
		if $(@).attr('id') == "new_activity"
			fb = "Thank You!"
		else
			fb = "Added!"
		$(@).find('.fb-enabled').val(fb).css('color', '#1dcfac')
		setTimeout ->
				$('.fb-enabled').val('').css('color', '#414141')
			, 750

	scrollDown: ->
		# $('.user-container')[0].scrollTop = 1000

	submitSettings: ->
		$('.edit_user').submit()

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
		$('.save-text').text("Saved")
		setTimeout ->
				$('.save-text').text("Save Settings")
			, 2000

	showSaving: ->
		$('.save-text').text("Saving...")

	showScrollActs: ->
		if $('.clone').length > 0
			$('.clone').html $('.all-scroll-acts').children()
			$('.clone').removeClass('clone')
		clone = $(@).parent().next().addClass('clone')
		acts = $(@).parent().next().children().clone()

		index =  $('.scroll-cat').index($(@).parent()) - 1
		$('.overlay').removeClass('orange-overlay')
		$('.cat-collection').scrollLeft (index * 125) + 20
		$('.all-scroll-acts').html acts
		$('.all-scroll-acts').prepend $('.all-scroll-acts .chosen')
		$(@).parent().find('.overlay').addClass('orange-overlay')
		id = $(@).parent().attr('id').slice 2
		$('#activity_category_id').val id

	addChosen: -> 
		$(@).parent().toggleClass('chosen') if $('.tut').length < 1
		$(@).parent().css 'background', '#14a29d' if $('.user-other-container:visible').length > 0
			
ready = ->
	MobileUsers.init()
$(document).ready ready
$(document).on 'page:load', ready




