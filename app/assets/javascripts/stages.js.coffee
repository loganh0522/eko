jQuery -> 
  $('#stages').sortable
    axis: 'y'
    cursor: 'move'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
  $("#stages").disableSelection()
      