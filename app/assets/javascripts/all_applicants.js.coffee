jQuery ->   
  $('.nav-header').on 'click', '.filter', (event) ->
    
    if $(this).attr('class') == 'filter open-jobs'
      $('.open-job-body').show()
      $('.nav-header').find('.showing').hide().removeClass('showing')
      $('.open-job-body').addClass('showing')
    else if $(this).attr('class') == 'filter job-status'
      $('.job-status-body').show()
      $('.nav-header').find('.showing').hide().removeClass('showing')
      $('.job-status-body').addClass('showing')
    else if $(this).attr('class') == 'filter date-applied'
      $('.date-applied-body').show()
      $('.nav-header').find('.showing').hide().removeClass('showing')
      $('.date-applied-body').addClass('showing')

    return
    

  $('.applicant-nav').on 'click', '.checkbox', (event) ->
    filter_type = $(this).attr('data-id')
    
    table_rows = $('tbody').find('tr')

    for n in table_rows
      if $(n).attr('class') == filter_type
        $('.all-job-applicants').find('.' + filter_type).show()
      else 
        $('.all-job-applicants').find('.' + filter_type).hide()
      console.log($(n).attr('class') == filter_type)

    console.log(table_rows)
    




