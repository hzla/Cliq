EventForm = 
	init: ->
    $('body').on 'click', '.event-type', @chooseType
    $('body').on 'click', '.event-attr', @chooseTag
    $('body').on 'click', '.event-requirement', @chooseRequirement
    $('body').on 'submit', '#new_event', @checkFields

  checkFields: (event) ->
    emptyTitle = ($('#event_title').val() == "")
    emptyTime = ($('#event_start_time').val() == "")
    event.preventDefault() if emptyTime || emptyTitle
    $('#event_title').css('border', '1px solid red') if emptyTitle
    $('#event_start_time').css('border', '1px solid red') if emptyTime

  chooseType: ->
    if $(@).parents('#invites').length > 0 || $(@).parents('.filter-container').length > 0
      selected = $(@).hasClass('selected')
      $(@).parent().find('.event-type.selected').removeClass('selected')
      $(@).addClass('selected') if !selected
      return
    $(@).parent().find('.event-type.selected').removeClass('selected')
    $(@).addClass('selected')
    type = $(@).text()
    $('#event_event_type').val type if $('#event_event_type').length > 0

  chooseTag: ->
    $(@).toggleClass('selected')
    currentTags = $('.event-attr.selected .attr-text').map ->
      $(@).text().replace("Drinks", "Party").split(' ').pop();
    $('.tags').val $.makeArray(currentTags).join() if $('.tags').length > 0
    $(@).addClass("stupid-safari").removeClass("stupid-safari")

  chooseRequirement: ->
    $(@).toggleClass('selected')
    currentReqs = $('.event-requirement.selected .require-text').map ->
      $(@).text()
    $('.requirements').val $.makeArray(currentReqs).join()

ready = ->
	EventForm.init()
$(document).ready ready
$(document).on 'page:load', ready


