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

  $('#main-container').on 'click', '#tag_name', (event) ->    
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
        $('tag_name').val ui.item.name 
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.name + "</a>").appendTo ul

  $('#main-container').on 'click', '#add-tag-button', (event) ->
    tagName = $('#tag_name').val()
    values =  $('#tags').val() + ',' + tagName 
    
    if $('#tags').val() == ''
      $('#tags').val tagName
    else
      $('#tags').val values   
    $('#tags_to_add').append('<div class="user-tag"> <div class="name">' + tagName  + '</div> <div class="delete-tag"> &times </div> </div>') 
    $('#tag_name').val('')


