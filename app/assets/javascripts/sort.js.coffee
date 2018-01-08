jQuery ->
  $('#stages').sortable
    axis: 'y'
    cursor: 'move'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))  
  $("#stages").disableSelection()

  $('#default-stages').sortable
    axis: 'y'
    cursor: 'move'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))  
  $("#default-stages").disableSelection()

  $('#questions').sortable
    axis: 'y'
    cursor: 'move'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
  $("#stages").disableSelection()