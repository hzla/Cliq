Events = 
	init: ->
		$('#event_start_time').datetimepicker
    	dateFormat: 'yy-mm-dd'
    	timeFormat: 'hh:mm:tt'
    $('#upload-button').click @browseFiles
    $('.invite-action').click @removeInvite 
    $('body').on 'change', '#event_partner_id', @addPartnerInfo

	browseFiles: ->
  	$('#event_image').click()

	removeInvite: ->
  	$(this).parents().eq(2).hide()

  addPartnerInfo: ->
    partnerId = $('#event_partner_id')[0].value
    $.get '/partners/' + partnerId + '.json', (data) ->
      $('#event_location')[0].value = data.location
      $('#hour-labels').parent().show()
      $('.event-modal').css "height", "625px"
      $('#mon').text data.mon
      $('#tues').text data.tues
      $('#wed').text data.wed
      $('#thurs').text data.thurs
      $('#fri').text data.fri
      $('#sat').text data.sat
      $('#sun').text data.sun



    






ready = ->
	Events.init()
$(document).ready ready
$(document).on 'page:load', ready


