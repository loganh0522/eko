$(document).ajaxComplete ->
  $('form').on 'click', '#job-team-search', ->  
    $(this).autocomplete( 
      source: '/business/users'
      appendTo: $('#search-results')     
      focus: (event, ui) -> 
        $('#search-results').val ui.item.first_name + ui.item.last_name
        false
      select: (event, ui) ->        
        $('#job-team-search').val('') 
        $('#hiring_team_user_id').val ui.item.id
        $('.modal-body').find('.users').append('
          <div class="user"> <div class="name">' + ui.item.full_name  + '</div> <div class="glyphicon glyphicon-remove"> </div> </div>') 

        if $('#user_ids').val() == ''
          values = ui.item.id
        else
          values =  $('#user_ids').val() + ',' + ui.item.id
        false
        $('#user_ids').val values

    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul 
    return
  return

  


