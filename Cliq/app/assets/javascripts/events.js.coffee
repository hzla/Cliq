Events = 
	init: ->
		$('#event_start_time').datetimepicker
    	dateFormat: 'yy-mm-dd'
    	timeFormat: 'hh:mm:tt'

    $('#upload-button').click @browseFiles

  browseFiles: ->
  	$('#event_image').click()






ready = ->
	Events.init()
$(document).ready ready
$(document).on 'page:load', ready


