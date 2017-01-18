jQuery -> 
  $('.add-comment-on-applicant').find('.user-comment').on 'keypress', (e)-> 
    console.log('key pressed')
    if e.keyCode == 64
      $('.add-comment-on-applicant').find(".user-comment").autocomplete(
        source: (request, response) ->  
          console.log(request.term[1..])
          console.log(request)
          $.ajax
            url: '/business/job_hiring_team'
            dataType: 'json'
            data:
              term: request.term[1..]
              job: $('#comment-body').data('job-id')
            success: (data) ->
              response data
              console.log(data)
              return
          return

        appendTo: $('#comment-team-members')
        focus: (event, ui) ->
          $('#team-member-results').val ui.item.name
          false
        
        select: (event, ui) ->
          $('#user-image').append('<div>' + ui.item.full_name + '<div>')
          $('.add-comment-on-applicant').find('#job_team_members').val ui.item.full_name 
          values =  $('#user_ids').val() + ',' + ui.item.id 
          $('#user_ids').val values
          $('#job_team_members').val('')
          false
      ).data('ui-autocomplete')._renderItem = (ul, item) ->
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
      return
    return
  return
    


    