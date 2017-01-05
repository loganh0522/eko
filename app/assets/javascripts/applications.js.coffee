jQuery -> 
  
  $('form_tag').on 'click', '.move_action', (event) ->
    checkbox = $('.applicant-checkbox')
    
    applicant_ids = []
    applicants = []
    applicant_names = []

    for n in checkbox   
      if $(n).find('input').is(':checked') == true     
        applicant = []
        applicant_ids.push($(n).data('id')) unless applicant_ids.includes($(n).data('id'))
        applicant.push($(n).data('id')) unless applicant.includes($(n).data('id'))
        
        applicant.push($(n).parent().parent().find('.name').data('id')) unless applicant.includes($(n).parent().parent().find('.name').data('id'))
        applicants.push(applicant) 

    $('#stageModal').find('form').find('#applicant_ids').val(applicant_ids)

    for n in applicants
      $('#stageModal').find('.recipients').append('<div id="applicant" data-id=' + n[0] + '> <div class="name">' + n[1] + '</div> <div class="remove-recipient"> &times </div> </div>') unless applicants.length == $('.recipients').children().length - 1 

  $('#stageModal').on 'click', '.remove-recipient', (event) -> 
    $('#stageModal').find('form').find('#applicant_ids').val("")
    
    $(this).parent().remove()
    new_recipients = $('.recipients').children()
    applicant_ids = []
    
    for n in new_recipients
      applicant_ids.push($(n).data('id'))
    
    $('#stageModal').find('form').find('#applicant_ids').val(applicant_ids)

  $('#stageModal').on 'hidden.bs.modal', ->
    $('.recipients').children().remove() 

    return

##################### Add Note on Multiple Modal ###########################

  $('form_tag').on 'click', '.add_note_action', (event) ->
    checkbox = $('.applicant-checkbox')
    
    applicant_ids = []
    applicants = []
    applicant_names = []

    for n in checkbox   
      if $(n).find('input').is(':checked') == true     
        applicant = []
        applicant_ids.push($(n).data('id')) unless applicant_ids.includes($(n).data('id'))
        applicant.push($(n).data('id')) unless applicant.includes($(n).data('id'))
        
        applicant.push($(n).parent().parent().find('.name').data('id')) unless applicant.includes($(n).parent().parent().find('.name').data('id'))
        applicants.push(applicant) 

    $('#add_commentModal').find('form').find('#applicant_ids').val(applicant_ids)

    for n in applicants
      $('#add_commentModal').find('.recipients').append('<div id="applicant" data-id=' + n[0] + '> <div class="name">' + n[1] + '</div> <div class="remove-recipient"> &times </div> </div>') unless applicants.length == $('.recipients').children().length - 1 

  $('#add_commentModal').on 'click', '.remove-recipient', (event) -> 
    $('#add_commentModal').find('form').find('#applicant_ids').val("")
    
    $(this).parent().remove()
    new_recipients = $('.recipients').children()
    applicant_ids = []
    
    for n in new_recipients
      applicant_ids.push($(n).data('id'))
    
    $('#add_commentModal').find('form').find('#applicant_ids').val(applicant_ids)

  $('#add_commentModal').on 'hidden.bs.modal', ->
    $('.recipients').children().remove() 

    return

##################### Send Message to Multiple Modal ###########################

  $('form_tag').on 'click', '.send_message', (event) ->
    checkbox = $('.applicant-checkbox')
    
    applicant_ids = []
    applicants = []
    applicant_names = []

    for n in checkbox   
      if $(n).find('input').is(':checked') == true     
        applicant = []
        applicant_ids.push($(n).data('id')) unless applicant_ids.includes($(n).data('id'))
        applicant.push($(n).data('id')) unless applicant.includes($(n).data('id'))
        
        applicant.push($(n).parent().parent().find('.name').data('id')) unless applicant.includes($(n).parent().parent().find('.name').data('id'))
        applicants.push(applicant) 

    $('#send_messageModal').find('form').find('#applicant_ids').val(applicant_ids)

    for n in applicants
      $('#send_messageModal').find('.recipients').append('<div id="applicant" data-id=' + n[0] + '> <div class="name">' + n[1] + '</div> <div class="remove-recipient"> &times </div> </div>') unless applicants.length == $('.recipients').children().length - 1 

  $('#send_messageModal').on 'click', '.remove-recipient', (event) -> 
    $('#send_messageModal').find('form').find('#applicant_ids').val("")
    
    $(this).parent().remove()
    new_recipients = $('.recipients').children()
    applicant_ids = []
    
    for n in new_recipients
      applicant_ids.push($(n).data('id'))
    
    $('#send_messageModal').find('form').find('#applicant_ids').val(applicant_ids)

  $('#send_messageModal').on 'hidden.bs.modal', ->
    console.log('closed')
    $('.recipients').children().remove() 

    return

###################### Insert Fluid Variable into E-mail #####################

  $('#insert-fluid-variable').change -> 
    if $('#insert-fluid-variable').val() == "Applicant First Name"
      $('#message-body').val($("#message-body").val() + "{{recipient.first_name}}")

    else if $('#insert-fluid-variable').val() == "Applicant Last Name"
      $('#message-body').val($("#message-body").val() + "{{recipient.last_name}}")
    else if $('#insert-fluid-variable').val() == "Applicant Full Name"
      $('#message-body').val($("#message-body").val() + "{{recipient.full_name}}")
    else if $('#insert-fluid-variable').val() == "Job Title"
      $('#message-body').val($("#message-body").val() + "{{job.title}}")
    else if $('#insert-fluid-variable').val() == "Company Name"
      $('#message-body').val($("#message-body").val() + "{{company.name}}")

    

