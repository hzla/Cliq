Events = 
	init: ->
		$('#event_start_time').datetimepicker
    	dateFormat: 'yy-mm-dd'
    	timeFormat: 'hh:mm:tt'





ready = ->
	Events.init()
$(document).ready ready
$(document).on 'page:load', ready


