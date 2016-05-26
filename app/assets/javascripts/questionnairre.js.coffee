jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.remove_question', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    $(this).parent().nextUntil('.questions').find('input[type=hidden]').val('1')
    $(this).parent().closest('.question-area').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'change', '.answer-type', (event) -> 
    val = $(this).find('.question-type').val()

    if val == "Checkbox" || val == "Multiple Choice"  
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).parent().after($(this).parent().next().data('fields'))
      $(this).parent().nextAll('.answers').show()
      $(this).parent().nextAll('.answers').find('input[type=hidden]').val('0')
      $(this).parent().nextAll('.add_fields').show()
      event.preventDefault()

    if val == "Text" || val == "Paragraph"
      $(this).parent().nextAll('.answers').hide()
      $(this).parent().nextAll('.answers').find('input[type=hidden]').val('1')
      $(this).parent().nextAll('.add_fields').hide()

  $(document).ready ->
    val = $('form').find('.answer-type').find('.question-type')
    len = val.length

    i = 0
    while i < len
      if $(val[i]).val() == "Checkbox" || $(val[i]).val() == "Multiple Choice"  
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(val[i]).parent().parent().nextAll('.add_fields').show()
        event.preventDefault() 
      else 
        $(val[i]).parent().parent().nextAll('.add_fields').hide()
        event.preventDefault() 
      i++

    
      

    