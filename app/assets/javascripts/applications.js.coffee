jQuery -> 
  $('table').on 'click', '.checkbox', (event) -> 
    $(this).find('input').attr('checked', true)

  $('form_tag').on 'click', '.move_action', (event) ->
    checkbox = $('.applicant-checkbox')
    applicants = []
    applicant_names = []

    for n in checkbox 
      if $(n).find('input').is(':checked') == true
        applicants.push($(n).data('id'))
        applicant_names.push($(n).parent().parent().find('.name').data('id'))

    $('#stageModal').find('form').find('#applicant_ids').val(applicants)


  $('form_tag').on 'click', '.add_note_action', (event) ->
    checkbox = $('.applicant-checkbox')
    applicants = []

    for n in checkbox 
      if $(n).find('input').is(':checked') == true
        applicants.push($(n).data('id'))

    $('#add_commentModal').find('form').find('#applicant_ids').val(applicants)


  $('form_tag').on 'click', '.send_message', (event) ->
    checkbox = $('.applicant-checkbox')
    applicants = []

    for n in checkbox 
      if $(n).find('input').is(':checked') == true
        applicants.push($(n).data('id'))

    $('#send_messageModal').find('form').find('#applicant_ids').val(applicants)
      