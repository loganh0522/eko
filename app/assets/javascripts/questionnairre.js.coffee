jQuery ->
  $('.main-container').on 'click', '.remove_fields', (event) ->
    $(this).next('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()
  $('.main-container').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

#### Scorecard #### 

  $('.main-container').on 'click', '.remove_question', (event) ->
    console.log('clicked')
    $(this).nextAll('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    $(this).parent().nextUntil('.questions').find('#destroy_fields').val('1')
    $(this).parent().closest('.scorecard-area').hide()
    event.preventDefault()

  $(document).ready ->
    if $('.scorecard-area').length >= 2 
      $('.remove_question').show()

#### ApplicationForm ####
  $('.main-container').on 'change', '.answer-type', (event) -> 
    val = $(this).find('.question-type').val()
    if val == "Checkbox" || val == "Multiple Choice"  
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).parent().after($(this).parent().next().data('fields'))
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

  $('.personal-social-links').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).after($(this).data('fields').replace(regexp, time))
    $(this).prev().find('.remove_fields').show()
    event.preventDefault()

  $('.experience-container').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    $(this).prev().find('.remove_fields').show()
    event.preventDefault()

  $(document).ready ->
    if $('.work-experience').length >= 2 
      $('.remove_fields:not(:first)').show()
    

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

  $('.main-container').on 'click', '#remove_form', (event) ->
    if $(this).closest('form').attr('class') == 'edit_comment'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").find('.activity-body-body').find('.comment-body').show()
      $(this).closest('form').remove()
    else if $(this).closest('form').attr('class') == 'edit_question'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").show()
      $(this).closest('form').remove()
    else if $(this).closest('form').attr('class') == 'edit_scorecard'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").show()
      $(this).closest('form').remove()
      $('.container-footer').show()
    else if $(this).closest('form').attr('class') == 'edit_task'
      $(this).parent().parent().parent().parent().find('.task-details').show()
      $(this).closest('form').remove()    
    else if $(this).closest('form').attr('class') == 'edit_application_scorecard'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").find('.activity-body-body').find('.comment-body').show()
      $(this).closest('form').remove()
    else
      $(this).closest('form').remove()
    return
    event.preventDefault()

################### Job Cart ####################
  $('#main-container').on 'click', '.add_to_cart', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#cart').find('.body').append($(this).data('fields').replace(regexp, time))

    totalAmount = 0

    $('.unit-price').each -> 
      totalAmount += Number($(this).val())

    $('#cart-total').find('.amount').html("$" + totalAmount)
    $('#order_total').val(totalAmount)
    event.preventDefault()

  $('#main-container').on 'click', '.remove_from_cart', (event) ->
    $(this).next('input[type=hidden]').val('1')
    id = $(this).parent().attr('id')
    $(this).closest('fieldset').remove()

    totalAmount = Number($('#cart-total').find('.amount').val())

    $('.unit-price').each -> 
      totalAmount += Number($(this).val())

    $('#cart-total').find('.amount').html("$" + totalAmount)
    $('#order_total').val(totalAmount)
    event.preventDefault()
