jQuery -> 
  $('form').on 'focus', '#team_members', ->
    $('form').find('#team_members').autocomplete(
      source: '/business/hiring_teams'
      appendTo: $('#team-members-results')
      focus: (event, ui) ->
        $('#team_members').val ui.item.name
        false
      select: (event, ui) ->
        $('#team_members').val ui.item.first_name 
        $('#user_id').val ui.item.id
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.first_name + "</a>").appendTo ul
    
    return
  return