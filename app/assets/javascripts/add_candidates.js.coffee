jQuery -> 
  
  $('.move-applicants').on 'click', (event) ->
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
    
    $(this).find('#applicant_ids').val(applicant_ids)

    for n in applicants
      $(this).find('.recipients').append('<div id="tag" data-id=' + n[0] + '> <div class="tag-name">' + n[1] + '</div> <div class="remove-recipient"> &times </div> </div>') 
  