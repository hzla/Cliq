Events = 
	init: ->
    $('#upload-button').click @browseFiles
    $('body').on 'ajax:success','.event-action', @removeInvite 
    $('body').on 'change', '#event_partner_id', @addPartnerInfo
    $('body').on 'ajax:success', '.event-sort', @sortEvents
    $('body').on 'ajax:success', '#new_event', @closeModal 
    $('body').on 'click', '#send-invite .invite-icon', @send
    $('body').on $.modal.BEFORE_CLOSE, '#invite-modal-container', @restoreOpacity
    $('body').on 'click', '#invites .form-row div', @filterEvents
    $('body').on 'click', '.filter-container .form-row div:not(#new-open-event)', @filterEvents
    $('body').on 'click', '.event-filter', @bigFilter

  bigFilter: ->
    if $('.mobile').length > 0
      $('.event-bar.selected').removeClass 'selected'
      $(@).parent().addClass('selected')
    else
      $('.event-filter.selected').removeClass 'selected'
      $(@).addClass('selected')

    $('.public-event-create').hide()
    $('.ev-overlay').css('opacity', '0')
    $('.public-event-create').show() if $('#event-hosting').parent().hasClass('selected')
    $('.ev-overlay').css('opacity', '') if $('#event-open').parent().hasClass('selected')

    $('.upcoming-event, .conversation').hide()
    if $('#event-open').hasClass('selected') || $('#event-open').parent().hasClass('selected')
      $('.upcoming-event, .conversation').show()
    if $('#event-going').hasClass('selected') || $('#event-going').parent().hasClass('selected')
      $('.joined').show()
    if $('#event-hosting').hasClass('selected') || $('#event-hosting').parent().hasClass('selected')
      $('.hosting').show()
    Events.filterEvents()

  filterEvents: ->
    currentTags = $('.event-attr.selected .attr-text').map ->
      $(@).text().split(' ').pop();
    tags = $.makeArray(currentTags).join()
    afterTags = ''
    if $('.event-types .event-type.selected')
      afterTags += ("," + $('.event-types .event-type.selected').text())
    if $('.event-date-types .event-type.selected')
      afterTags += ("," + $('.event-date-types .event-type.selected').text())
    tags = tags.split(",,").join(".").split(",").join(".")
    tags = tags.slice(0, tags.length - 1) if tags[tags.length - 1] == "."
    tags = "." + tags if tags != "" && tags[0] != "."
    tags += ".hosting" if $('#event-hosting').hasClass('selected') || $('#event-hosting').parent().hasClass('selected')
    tags += ".joined" if $('#event-going').hasClass('selected') || $('#event-going').parent().hasClass('selected')
    tags = tags.split('.').join(', .').slice(2)

    afterTags = afterTags.replace(',Any Time', '').split(',').join('.').replace('..', '.')
    afterTags = afterTags.slice(0, afterTags.length - 1) if afterTags[afterTags.length - 1] == "."
    
    if $('.mobile').length < 1
      tags =  tags.split('.').join(".upcoming-event#{afterTags}.")
    else
      tags = tags.split('.').join(".conversation#{afterTags}.")


    $('.upcoming-event').hide()
    $(".upcoming-event#{tags}".toLowerCase()).show().removeClass('animated fadeIn').addClass('animated fadeIn')
    
    $(".conversation").hide()
    $(".conversation#{tags}".toLowerCase()).show().removeClass('animated fadeIn').addClass('animated fadeIn')
    
    $('.date-header').hide()
    $('.date-header').parent().has(":visible").children(".date-header").show()



  send: ->
    $('#new_event').submit()

	browseFiles: ->
  	$('#event_image').click()

	removeInvite: ->
    invite = $(@).parents('.upcoming-event')
    if $(@).hasClass 'pass'
      console.log invite
      invite.removeClass('animated fadeIn').addClass 'animated bounceOutLeft'
      invite.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
        invite.animate {
          height: "0px"
        }, 200, ->
          invite.hide()
    else
      invite.addClass('joined')
      invite.find('.invite-action-buttons').hide()
      invite.find('.view-thread').show()

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
    Events.allotTimes()
    $('.upcoming-event').addClass('animated fadeIn')
    Events.filterEvents()
    

  closeModal: (event, data, xhr, status) ->
    if data.ok == true
      $.modal.close()
      location.reload();
    else
      $('#event_title').css('border', '1px solid red') if data.title
      $('#event_location').css('border', '1px solid red') if data.location
      $('#event_start_time').css('border', '1px solid red') if data.start_time

  allotTimes: ->
    $('.today-events').append $('.upcoming-event.today')
    $('.tommorow-events').append $('.upcoming-event.tommorow')
    dates = $('.upcoming-event:not(.today, .tommorow)').map ->
      $(@).attr('class').split(' ')[1]
    dates = $.makeArray($.unique(dates))
    $.each dates, ->
      splitDate = @.split("-").join(" ")
      $('.event-date-type').last().after "<div class='event-date-type #{@}'><div class='date-header head-2'>#{splitDate}</div></div>"
    $.each dates, ->
      $(".event-date-type.#{@}").append $(".upcoming-event.#{@}:not(.today, .tommorow)")
      





    






ready = ->
	Events.init()
$(document).ready ready
$(document).on 'page:load', ready


