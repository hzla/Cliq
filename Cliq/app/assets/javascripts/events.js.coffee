Events = 
	init: ->
    $('#upload-button').click @browseFiles
    $('body').on 'ajax:success','.invite-action', @removeInvite 
    $('body').on 'change', '#event_partner_id', @addPartnerInfo
    $('body').on 'ajax:success', '.event-sort', @sortEvents
    $('body').on 'ajax:success', '#new_event', @closeModal 

	browseFiles: ->
  	$('#event_image').click()

	removeInvite: ->
    invite = $(this).parents().eq(2)
    invite.addClass 'animated bounceOutLeft'
    invite.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      invite.animate {
        height: "0px"
      }, 200, ->
        invite.hide()

  addPartnerInfo: ->
    partnerId = $('#event_partner_id')[0].value
    $.get '/partners/' + partnerId + '.json', (data) ->
      $('#event_location')[0].value = data.location
      $('#hour-labels').parent().show()
      $('.event-modal').css "height", "615px"
      $('#mon').text data.mon
      $('#tues').text data.tues
      $('#wed').text data.wed
      $('#thurs').text data.thurs
      $('#fri').text data.fri
      $('#sat').text data.sat
      $('#sun').text data.sun
      $('#invite-modal-container').css "margin-top", parseInt($('#invite-modal-container').css('margin-top').slice(0, -2)) - 30 + "px"

  sortEvents: (event, data, xhr, status) ->
    console.log data
    eventType = $(@).children().text()
    $('.event-sort').children().removeClass 'selected'
    $(@).children().addClass 'selected'
    $('#events').html data
    $('#upcoming-header').text "#{eventType} Events:"

  closeModal: ->
    $.modal.close()



    






ready = ->
	Events.init()
$(document).ready ready
$(document).on 'page:load', ready


