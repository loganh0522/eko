jQuery -> 
  $('form').on 'focus', '#team_members', ->
    $('form').find('#team_members').autocomplete(
      source: '/business/hiring_teams'
      appendTo: $('#team-members-results')
      focus: (event, ui) ->
        $('#team_members').val ui.item.name
        false
      select: (event, ui) ->
        $('#team_members').val ui.item.full_name 
        $('#user_id').val ui.item.id
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
    
    return

  $('form').on 'focus', '#job_team_members', ->   
    job = ('#job_team_members')   
    $('form').find('#job_team_members').autocomplete( 
      source: (request, response) ->
        $.ajax
          url: '/business/job_hiring_team'
          dataType: 'json'
          data:
            term: request.term
            job: $('#job_team_members').data('job-id')
          success: (data) ->
            response data
            return
        return

      appendTo: $('#team-members-results')
      focus: (event, ui) ->
        $('#job_team_members').val ui.item.name
        false
      select: (event, ui) ->
        $('#user-image').append('<div>' + ui.item.full_name + '<div>')
        $('#job_team_members').val ui.item.full_name 
        values =  $('#user_ids').val() + ',' + ui.item.id 
        $('#user_ids').val values
        $('#job_team_members').val('')
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
    
    return

  $('form').on 'click', '.insert', (event) -> 
    tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #EF7B2B; color: white; width: 100px; border-radius: 5px; height: 16px; text-align: center;'> {{ some text }}  </span>")







