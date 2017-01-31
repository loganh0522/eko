jQuery -> 

  $('.add-comment-on-applicant').find('.user-comment').on 'keypress', (e)-> 
    console.log("pressed")
    if e.keyCode == 64
      $('.add-comment-on-applicant').find(".user-comment").autocomplete(
        source: (request, response) ->  
          termIndex = request.term.indexOf('@') + 1
          $.ajax
            url: '/business/job_hiring_team'
            dataType: 'json'
            data:
              term: request.term[termIndex..]
              job: $('#submit-comment-btn').data('job-id')
            success: (data) ->
              response data
              return
          return

        appendTo: $('#comment-team-members')
        focus: (event, ui) ->
          $('#team-member-results').val ui.item.name
          false  
        select: (event, ui) -> 
          element = document.querySelector("trix-editor")
          element.editor.insertHTML("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'>" + ui.item.full_name + "</span>")         
          false
      ).data('ui-autocomplete')._renderItem = (ul, item) ->
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
      return
    return
  return
    


    