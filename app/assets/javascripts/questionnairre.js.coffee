jQuery ->
#### Scorecard #### 
  $(document).on 'click', '.remove_kit_question', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).parent().parent().parent().hide()

  $('.main-container').on 'click', '.remove_question', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    $(this).parent().nextUntil('.questions').find('#destroy_fields').val('1')
    $(this).parent().closest('.scorecard-area').hide()
    event.preventDefault()

  $(document).ready ->
    if $('.scorecard-area').length >= 2 
      $('.remove_question').show()

#### Question Answers ####
  $(document).on 'click', '.question-answer-checkbox', (event) -> 
    if $(this).is(':checked')
      $(this).next('input[type=hidden]').val('0')
    else
      $(this).next('input[type=hidden]').val('1')

#### ApplicationForm ####
  $(document).on 'change', '.question-type', (event) -> 
    val = $(this).children().val()
    if val == "Select (One)" || val == "Multiselect"  
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      add_fields = $(this).parent().next().find('.add_fields')
      add_fields.before(add_fields.data('fields'))
      add_fields.before(add_fields.data('fields'))
      add_fields.parent().show()
    else
      answers = $(this).parent().next().find('.answers')
      answers.hide()
      answers.find('input[type=hidden]').val('1')
      $(this).parent().next().find('.add_fields').hide()

  $(document).ready ->
    val = $('form').find('.answer-type').find('.question-type')
    len = val.length
    i = 0
    while i < len
      if $(val[i]).val() == "Select" || $(val[i]).val() == "Multiselect"  
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(val[i]).parent().parent().nextAll('.add_fields').show()
        event.preventDefault() 
      else 
        $(val[i]).parent().parent().nextAll('.add_fields').hide()
        event.preventDefault() 
      i++

################## Create Profile ##################    
  $(document).ready ->
    if $('.add-work-experience').length >= 1
      $('.remove_fields:not(:first)').show()
      

################ Create Application ###############

  $('.main-container').on 'click', '.remove_fields', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).parent().parent().hide()
    event.preventDefault()
  
  $('.create-profile-container').on 'click', '.remove_fields', (event) ->
    $(this).first().prev().val('1')
    $(this).parent().parent().hide()
    event.preventDefault()


  
  $(document).on 'click', '.add_fields_after', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).after($(this).data('fields').replace(regexp, time))
    $(this).prev().find('.remove_fields').show()
    event.preventDefault()

  $(document).on 'click', '.remove_fields', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).parent().parent().hide()
    event.preventDefault()

  $('.mediumModal, .largeModal').on 'click', '.remove_question', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    $(this).parent().nextUntil('.questions').find('#destroy_fields').val('1')
    $(this).parent().closest('.scorecard-area').hide()
    event.preventDefault()

  $('.mediumModal, .largeModal').on 'click', '.remove_fields', (event) ->
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).parent().parent().hide()
    event.preventDefault()


