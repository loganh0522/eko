jQuery -> 
  $(document).on 'click', '.add_tag', (event) ->    
    $('.tag_form').find('#tag_name').autocomplete( 
      source: (request, response) ->
        $.ajax
          url: '/business/tags'
          dataType: 'json'
          data:
            term: request.term
          success: (data) ->
            response data
            return
        return

      appendTo: $('#tag-results')
      focus: (event, ui) ->
        $('#tag_name').val ui.item.name
        false
      select: (event, ui) ->
        $('#tag_name').val ui.item.name 
        $('#tag_id').val ui.item.id 
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.name + "</a>").appendTo ul

  $('#addTagsModal').on 'click', '#tag_name', (event) ->    
    $(this).autocomplete( 
      source: (request, response) ->
        $.ajax
          url: '/business/tags'
          dataType: 'json'
          data:
            term: request.term
          success: (data) ->
            response data
            return
        return

      appendTo: $('#tag-results')
      focus: (event, ui) ->
        $('#tag_name').val ui.item.name
        false
      select: (event, ui) ->
        $('#tag_name').val ui.item.name 
        $('#tag_id').val ui.item.id 
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.name + "</a>").appendTo ul