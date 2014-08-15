Search = 
	init: ->
		@autocompleteLocations()
		@autocompleteInterests()
		$('.tab').on 'ajax:success', @autoCompleteAll
		$('body').on 'ajax:success', '#search-form', @displayResults
		$('body').on 'ajax:success', '#search-form', @getResultInfo
		$('body').on 'submit', '#search-form', @displaySearching
		$('.send-activation').on 'submit', @thankUser
		$('body').on 'click', '.searched', @removeTerm
		$('body').on 'keypress', '#activity', @selectInterestOnEnter
		$('body').on 'click', '.cliq-invite', @inviteFriends
		$('body').on 'ajax:success', '#friend-invite', @sendCliqInvite
		$('body').on 'keydown', '#query-location' , @deleteLocID
		
	autoCompleteAll: ->
		Search.autocompleteLocations()
		Search.autocompleteInterests()

	autocompleteLocations: ->
		$('#query-location').autocomplete
			source: '/locations'
			select: (event, ui) ->
				event.preventDefault()
				$(this).val ui.item.label
				$('#location_id').val ui.item.value
			focus: (event, ui) ->
				event.preventDefault()
				$(this).val ui.item.label
	
	autocompleteInterests: ->
		if $('#activity').length > 0
			$('#activity').autocomplete(
				source: '/activities'
				select: (event, ui) ->
					event.preventDefault()
					$(@).val ui.item.label
					$('#ids').val $('#ids').val() + ui.item.value + " "
					label = ui.item.label.slice(0,25)
					if label.length > 24
						label += "..."
					$('#query-interests').prepend "<div class='query-interest search-term searched' id='#{ui.item.value}'>#{label}</div>"
					$('#activity').val('')
					$(@).css 'color', '#939393'
					$('#search-form').submit() if $('.mobile').length < 1 || $('.enable-auto-search').length > 0
				focus: (event, ui) ->
					event.preventDefault()
					$(@).val ui.item.label
					$(@).css 'color', '#414141'
					$('.ui-state-focus').removeClass('ui-state-focus').addClass 'new-focus'
				delay: 0
				open: (event, ui) -> 
					$('.ui-autocomplete').find('.ac-image').removeClass 'hidden'
					$('.ui-menu-item').each ->
					$('.ui-autocomplete').css 'width', '+=50px'
				minLength: 2
				response: (event, ui) ->
			).data("uiAutocomplete")._renderItem = (ul, item) ->
				icon = $("##{item.type}").clone()
				console.log item
				console.log icon
				a = $("<li />").data("item.autocomplete", item).append("<a class='item-label'>#{item.label}</a>").appendTo(ul).prepend icon	 
				return a
        
	removeTerm: ->
		id= @.id
		ids = $('#ids')[0].value
		new_ids = ids.replace "#{id} ", ""
		$('#ids').val new_ids
		$(@).remove()

	displayResults: (event, data, xhr, status) ->
		if $('.mobile').length < 1 || $('.enable-auto-search').length > 0
			$('#search-results').html data
			$('.result').addClass 'animated fadeIn'
			$('#results').html data
			$('.swiped-result').hide()
			$('.swiped-result').each (index) ->
				if index != 0 && index % 10 == 0
					empty = $('#empty').clone()
					$(@).replaceWith empty
			$('#results').children().first().show().removeClass('hidden').addClass 'animated fadeIn'
			if $('#empty').length > 0
				$('#no-one-around').show()
			$('body').scrollTo($('.mobile .result')) if $('.searched').length < 1 && $('.mobile').length > 0

	getResultInfo: ->
		$('.result, .swiped-result').each ->
			if !$(@).hasClass('no-complete')
				id = $(@).attr('id').slice(2)
				result = $(@)
				$.get "users/#{id}/result_info", (data) ->
					result.find('.mut-stat').text data.mut
					result.find('.sim-stat').text data.sim

	displaySearching: ->
		$('#search-results').html "<div id='searching'>SEARCHING...</div>"

	thankUser: (event, data, xhr, status) ->
		if $('#email').val().match(/.+@.+\..+/i) != null
			$('#top').html ""
			$('#top').html "<div id='ty'>Thank you for signing up. Please check your email and<br> refresh the page when you've been activated</div>" 
			$('#top').css 'right', '60px'
			$('#ty').addClass 'animated fadeIn'
		else
			$('#top').html ""
			$('#top').html "<div id='ty'>Please enter a valid email to sign up</div>" 
			$('#top').css 'right', '152px'
			$('#ty').addClass 'animated fadeIn'

	selectInterestOnEnter: (e) ->
		if (e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)
			$('.ui-menu-item:visible').first().click()

	inviteFriends: ->
		box = $(@).parents('.no-one-around')
		box.find('.pre-invite').hide()
		box.find('.post-invite').show()
		box.css 'height', '570px'

	sendCliqInvite: ->
		$(@)[0].reset()
		$('.sent-invite').show().addClass 'animated fadeIn'
		setTimeout ->
			$('.sent-invite').hide()
		, 1000

	deleteLocID: ->
		key = event.keyCode || event.charCode
		if  key == 8 || key == 46 
			$('#location_id').val ''
	

ready = ->
	Search.init()
$(document).ready ready
$(document).on 'page:load', ready
