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
  $("#questions").disableSelection()


  $('#board-sections').sortable
    axis: 'y'
    cursor: 'move'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
  $("#board-sections").disableSelection()

  $(document).ajaxComplete ->
    $('#nested-attributes, #scorecard-sections').sortable
      axis: 'y'
      cursor: 'move'
      stop: -> 
        numberElems = $('.question-area').length;
        $('.position').each (idx) ->
          $(this).val idx + 1
          return


