jQuery ->
  $('.applicant-profile-information').find('.user-comment').on 'keypress', (e)->
    if e.keyCode == 64
      $('.applicant-profile-information').find(".user-comment").autocomplete(
        source: (request, response) ->  
          console.log(request.term)
          termIndex = request.term.indexOf('@') + 1
          $.ajax
            url: '/business/job_hiring_team'
            dataType: 'json'
            data:
              term: request.term[termIndex..]
              job: $('.applicant-profile-information').find('.user-comment').data('job-id')
            success: (data) ->
              response data
              return
          return

        appendTo: $('#comment-team-members')
        focus: (event, ui) ->
          $('#team-member-results').val ui.item.name
          false  
        select: (event, ui) -> 
          termIndex = $('.applicant-profile-information').find('#comment-body').html().indexOf('@')
          term = $('.applicant-profile-information').find('#comment-body').html().slice(/(\@)(.*?)(?=\s)/)
          $('.applicant-profile-information').find('#comment-body').html().replace(term, ' ')
          
          $('.applicant-profile-information').find('#comment-body').append("<span contentEditable= 'false'; overflow='hidden'; class='class_one'; style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'>" + ui.item.full_name + "</span>")        
          false
      ).data('ui-autocomplete')._renderItem = (ul, item) ->
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
      return
    return
  return
    


    