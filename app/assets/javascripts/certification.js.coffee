jQuery -> 
  $(document).ajaxComplete (event, xhr, settings) ->
    
    if settings.url == "http://localhost:3000/job_seeker/work_experiences/new"
      $("#geocomplete").geocomplete()

      $('#find').click ->
        $('input').trigger 'geocode'
      return

    else
      $('#certification_name').autocomplete(
        source: '/certifications'
        appendTo: $('#certification-results')
        focus: (event, ui) ->
          $('#certification_name').val ui.item.name
          false
        select: (event, ui) ->
          $('#certification_name').val ui.item.name 
          $('#certification_id').val ui.item.id
          false
      ).data('ui-autocomplete')._renderItem = (ul, item) ->
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.name + "</a>").appendTo ul
    return
  return


