Events = 
	init: ->
    $('#upload-button').click @browseFiles
    $('body').on 'ajax:success','.invite-action', @removeInvite 
    $('body').on 'change', '#event_partner_id', @addPartnerInfo
    $('body').on 'ajax:success', '.event-sort', @sortEvents
    $('body').on 'ajax:success', '#new_event', @closeModal 
    $('body').on 'click', '#send-invite .invite-icon', @send
    $('body').on $.modal.BEFORE_CLOSE, '#invite-modal-container', @restoreOpacity

  send: ->
    $('#new_event').submit()

	browseFiles: ->
  	$('#event_image').click()

	removeInvite: ->
    invite = $(this).parents('.upcoming-event')
    invite.addClass 'animated bounceOutLeft'
    invite.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      invite.animate {
        height: "0px"
      }, 200, ->
        invite.hide()

  restoreOpacity: (event, modal) ->
    if $('.user-other-container:visible').length > 0 || $('.chat-partial:visible').length > 0
      $('.content-container').css 'opacity', '.3'

  addPartnerInfo: ->
    partnerId = $('#event_partner_id')[0].value
    $.get '/partners/' + partnerId + '.json', (data) ->
      $('#event_location')[0].value = data.location
      $('#hour-labels').parent().show()
      $('.event-modal').css "height", "640px"
      $('#invite-modal-container').css "margin-top", "-340px"
      $('#mon').text data.mon
      $('#tues').text data.tues
      $('#wed').text data.wed
      $('#thurs').text data.thurs
      $('#fri').text data.fri
      $('#sat').text data.sat
      $('#sun').text data.sun
      $('#invite-modal-container').css "margin-top", parseInt($('#invite-modal-container').css('margin-top').slice(0, -2)) - 30 + "px"

  sortEvents: (event, data, xhr, status) ->
    eventType = $(@).children().text()
    $('.event-sort').children().removeClass 'selected'
    $(@).children().addClass 'selected'
    $('#events-box').html data
    $('#upcoming-header').text "#{eventType} Events:"

  closeModal: (event, data, xhr, status) ->
    console.log data
    if data.ok == true
      $.modal.close()
      location.reload();
    else
      $('#event_title').css('border', '1px solid red') if data.title
      $('#event_location').css('border', '1px solid red') if data.location
      $('#event_start_time').css('border', '1px solid red') if data.start_time




    






ready = ->
	Events.init()
$(document).ready ready
$(document).on 'page:load', ready


