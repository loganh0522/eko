jQuery -> 
  $('table').on 'click', '.checkbox', (event) -> 
    console.log('checked')
    $(this).find('input').attr('checked', true)

  $('form_tag').on 'click', '.move_action', (event) ->
    checkbox = $('.checkbox')
    applicants = []

    for n in checkbox 
      console.log($(n).find('input').is(':checked'))
      if $(n).find('input').is(':checked') == true
        applicants.push($(n).data('id'))
        console.log("is check")

    console.log(applicants)
    $('#stageModal').find('form').find('#applicant_ids').val(applicants)

      