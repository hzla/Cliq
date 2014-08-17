EventForm = 
	init: ->
    $('body').on 'click', '.event-type', @chooseType
    $('body').on 'click', '.event-attr', @chooseTag
    $('body').on 'click', '.event-requirement', @chooseRequirement

  chooseType: ->
    $('.event-type.selected').removeClass('selected')
    $(@).addClass('selected')
    $('#event_event_type').val $(@).text() 

  chooseTag: ->
    $(@).toggleClass('selected')
    currentTags = $('.event-attr.selected .attr-text').map ->
      $(@).text().split(' ').pop();
    $('.tags').val $.makeArray(currentTags).join()

  chooseRequirement: ->
    $(@).toggleClass('selected')
    currentReqs = $('.event-requirement.selected .require-text').map ->
      $(@).text()
    $('.requirements').val $.makeArray(currentReqs).join()







ready = ->
	EventForm.init()
$(document).ready ready
$(document).on 'page:load', ready


