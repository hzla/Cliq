Categories = 
	init: ->
		$('body').on 'click', '.cat', @highlight
		$('body').on 'ajax:success', '.cat-link', @showCategories
		$('body').on 'ajax:success', '.back-link', @showCategories
		$('body').on 'ajax:success', '.add-act', @addActivity
		$('body').on 'ajax:success', '.remove-act', @removeActivity

	highlight: ->
		$(@).children('.cat-title').css 'color', 'white' 
		$(@).children('.cat-title').css 'background-color', '#13CD81'
		$(@).find('.check').toggle()

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








ready = ->
	Categories.init()
$(document).ready ready
$(document).on 'page:load', ready