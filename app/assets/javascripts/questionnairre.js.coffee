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

  $('form').on 'change', '.question-type', (event) -> 
    val = $(this).val()

    if val == "Checkbox" 
      console.log("checkbox")   
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).parent().after($(this).parent().next().data('fields'))
      $(this).parent().nextAll('.answers').show()
      $(this).parent().nextAll('.answers').find('input[type=hidden]').val('0')
      $(this).parent().nextAll('.add_fields').show()
      event.preventDefault()

    if val == "Text" || val == "Paragraph"
      console.log("text")
      $(this).parent().nextAll('.answers').hide()
      $(this).parent().nextAll('.answers').find('input[type=hidden]').val('1')
      $(this).parent().nextAll('.add_fields').hide()




    
