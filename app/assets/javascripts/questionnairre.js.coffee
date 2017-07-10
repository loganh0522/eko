jQuery ->
  $('.job_scorecard').on 'click', '.remove_fields', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('.job_scorecard').on 'click', '.remove_question', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    $(this).parent().nextUntil('.questions').find('input[type=hidden]').val('1')
    $(this).parent().closest('.question-area').hide()
    event.preventDefault()

  $('.job_scorecard').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()


  $('.job_scorecard').on 'change', '.answer-type', (event) -> 
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

################## Create Profile ##################    
      
  $('.create-profile-container').on 'click', '.remove_fields', (event) ->
    $(this).parent().parent().remove()
    event.preventDefault()

  $('.create-profile-container').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    $(this).prev().find('.remove_fields').show()
    event.preventDefault()

################ Create Application ###############

  $('#basic-form-modal').on 'click', '.remove_fields', (event) ->
    $(this).parent().parent().remove()
    event.preventDefault()

  $('#basic-form-modal').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).after($(this).data('fields').replace(regexp, time))
    $(this).prev().find('.remove_fields').show()
    event.preventDefault()
    $('#task_due_date').datepicker  
      dateFormat: 'yy-mm-dd'
    $('#timepicker').timepicker()


    
