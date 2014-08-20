EventForm = 
	init: ->
    $('body').on 'click', '.event-type', @chooseType
    $('body').on 'click', '.event-attr', @chooseTag
    $('body').on 'click', '.event-requirement', @chooseRequirement

  chooseType: ->
    if $(@).parents('#invites').length > 0
      selected = $(@).hasClass('selected')
      $(@).parent().find('.event-type.selected').removeClass('selected')
      $(@).addClass('selected') if !selected
      return
    $(@).addClass('selected')
    type = $(@).text()
    $('#event_event_type').val type if $('#event_event_type').length > 0

  chooseTag: ->
    $(@).toggleClass('selected')
    currentTags = $('.event-attr.selected .attr-text').map ->
      $(@).text().split(' ').pop();
    $('.tags').val $.makeArray(currentTags).join() if $('.tags').length > 0

  chooseRequirement: ->
    $(@).toggleClass('selected')
    currentReqs = $('.event-requirement.selected .require-text').map ->
      $(@).text()
    $('.requirements').val $.makeArray(currentReqs).join()







ready = ->
	EventForm.init()
$(document).ready ready
$(document).on 'page:load', ready


