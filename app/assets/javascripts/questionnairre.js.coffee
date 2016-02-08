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


    
