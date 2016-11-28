jQuery -> 
  $(document).ajaxComplete (event, xhr, settings) ->
    if settings.url == "http://localhost:3000/business/jobs/39/applications/18/tags/new"
      $('#tag_name').autocomplete(
        source: '/business/tags'
        appendTo: $('#tag-results')
        focus: (event, ui) ->
          $('#tag_name').val ui.item.name
          false
        select: (event, ui) ->
          $('#tag_id').val ui.item.id
          false
      ).data('ui-autocomplete')._renderItem = (ul, item) ->
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.name + "</a>").appendTo ul
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


