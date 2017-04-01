# jQuery -> 
#  $('#skills_name').autocomplete(
#     source: '/skills'
#     appendTo: $('#skills-results')
#     focus: (event, ui) ->
#       $('#skills_name').val ui.item.name
#      false
#     select: (event, ui) ->
#      $('#skills_name').val ui.item.name 
#       $('#skills_id').val ui.item.id
#      false
#   ).data('ui-autocomplete')._renderItem = (ul, item) ->
#    $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.name + "</a>").appendTo ul
  
#   return