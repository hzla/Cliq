Categories = 
	init: ->
		$('body').on 'click', '.cat', @highlight
		$('body').on 'click', '#next-cat', @goNext
		$('body').on 'ajax:success', '.cat-link', @showCategories
		$('body').on 'ajax:success', '.back-link', @showCategories
		$('body').on 'ajax:success', '.add-act', @addActivity
		$('body').on 'ajax:success', '.remove-act', @removeActivity
		$('body').on 'ajax:success', '#new_activity', @suggestActivity

	highlight: ->
		$(@).children('.cat-title').css 'color', 'white' 
		$(@).children('.cat-title').css 'background-color', '#18c3bd'
		$(@).find('.check').toggle()

	goNext: ->
		$('.doing').parent().next()[0].click()

	showCategories: (event, data, xhr, status) ->
		$('#categories-content-container').remove()
		$('.content-container').append data
		$('#categories-footer').before $('#categories-content-container')[0]
		$($('#categories-content-container')[1]).remove()
		$('#categories-content-container').addClass 'animated fadeIn'


	addActivity: (event, data, xhr, status) ->
		$(@).remove()
		$('#chosen-acts').append data
		likeCount = parseInt($('#like-count').text())
		$('#like-count').text likeCount - 1
		if likeCount == 1
			$('#cat-footer-content').hide()
			$('#next-cat').show()

	removeActivity: (event, data, xhr, status) ->
		$(@).remove()
		$('#activities').prepend data
		likeCount = parseInt($('#like-count').text())
		$('#like-count').text likeCount + 1
		if likeCount == 0
			$('#cat-footer-content').show()
			$('#next-cat').hide()

	suggestActivity: ->
		@.reset()
		$('#thank-suggestion').remove()
		$('#suggestion-container').append "<div id='thank-suggestion'>Thank you, your suggestion will be looked over and added if appropriate.</div>"
		$('#thank-suggestion').show().addClass('animated fadeIn')
		console.log "tried"









ready = ->
	Categories.init()
$(document).ready ready
$(document).on 'page:load', ready