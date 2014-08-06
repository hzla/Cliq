Categories = 
	init: ->
		@autocompleteQS()
		$('body').on 'click', '.cat', @highlight
		$('body').on 'click', '#next-cat', @goNext
		$('body').on 'ajax:success', '.cat-link', @showCategories
		$('body').on 'ajax:success', '.back-link', @showCategories
		$('body').on 'ajax:success', '.add-act', @addActivity
		$('body').on 'ajax:success', '.remove-act', @removeActivity
		$('body').on 'ajax:success', '#new_activity', @suggestActivity
		$('body').on 'ajax:success', '#quick-search', @quickAdd 
		$('body').on 'click', '#suggest-text', @prepSuggest
		$('body').on 'ajax:success', '.top-nav-content a', @autocompleteQS

	prepSuggest: ->
		$(@).hide()
		$('#activity_name').show()
		$('#new_activity').css 'margin-top', '40px'
		$('#new_activity').css 'margin-top', '205px' if $('#quick-search:visible').length > 0

	highlight: ->
		$(@).children('.cat-title').css 'color', 'white' 
		$(@).children('.cat-title').css 'background-color', '#ffa320'

	goNext: ->
		$('.doing').parent().next()[0].click()

	showCategories: (event, data, xhr, status) ->
		$('#categories-content-container').remove()
		$('.content-container').append data
		$('#categories-content-container').addClass 'animated fadeIn'
		url = @.href.split('/')
		if url[url.length - 1] != 'choose'
			url.push 'select'
			url = url.join('/')
		else
			console.log url
			url[url.length - 1] = "select"
			url = url.join('/')
		
		history.pushState(null, document.title, url)
		
	addActivity: (event, data, xhr, status) ->
		$(@).remove()
		$('#chosen-acts').append data
		likeCount = parseInt($('#like-count').text())
		$('#like-count').text likeCount - 1
		if likeCount == 1
			$('#cat-footer-content').hide()
			$('#next-cat').show()
			$('#finish').show()

	removeActivity: (event, data, xhr, status) ->
		$(@).remove()
		$('#activities').prepend data
		likeCount = parseInt($('#like-count').text())
		$('#like-count').text likeCount + 1
		if likeCount == 0
			$('#cat-footer-content').show()
			$('#next-cat').hide()
			$('#finish').hide()

	suggestActivity: ->
		@.reset()
		$('#thank-suggestion').remove()
		$('#suggestion-container').append "<div id='thank-suggestion' class='gray'>Thank you for your suggestion</div>"
		$('#thank-suggestion').show().addClass('animated fadeIn')
		setTimeout ->
			$('#thank-suggestion').remove()
		, 3000


	autocompleteQS: ->
		$('.quick-search-acts').autocomplete
			source: '/activities'
			select: (event, ui) ->
				event.preventDefault()
				$(@).val ui.item.label
				$('#act_id').val ui.item.value
				$(@).css 'color', '#414141'
				console.log ui.item
				$('.interest-info').text ui.item.id + "@" + ui.item.root_id + "@" + ui.item.cat_name
			focus: (event, ui) ->
				event.preventDefault()
				$(@).val ui.item.label
				$(@).css 'color', '#414141'
				$('.interest-info').text ui.item.id
				$('.ui-state-focus').removeClass('ui-state-focus').addClass 'new-focus'
			delay: 0
			open: (event, ui) -> 
				$input = $(event.target)
				$results = $input.autocomplete("widget")
				top = $results.position().top
				height = $results.height()
				inputHeight = $input.height()
				newTop = top - height - inputHeight
				newTop -= 15
				$results.css("top", newTop + "px")
			minLength: 2

	quickAdd: ->
		id = "#" + $('#act_id').val()
		$(id).click()
		@.reset()
		$('#added').remove
		$('#quick-search-container').append "<div id='added' class='head-4 gray'>Added</div>"
		setTimeout ->
			$('#added').remove()
		, 2000
		likeCount = parseInt($('#like-count').text())
		$('#like-count').text likeCount - 1
		if likeCount == 1
			$('#cat-footer-content').hide()
			$('#next-cat').show()
			$('#finish').show()
		if $('.tut').length > 0
			intCount = parseInt($('#int-number').text()) - 1
			$('#int-number').text intCount

ready = ->
	Categories.init()
$(document).ready ready
$(document).on 'page:load', ready