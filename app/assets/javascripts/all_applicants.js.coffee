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

  $('.applicant-nav').on 'click', '.applicant-filter-checkbox', (event) ->    
    checked = []
    checkbox = $('.applicant-filter-checkbox')

    for n in checkbox 
      if $(n).find('input').is(':checked') == true
        checked.push($(n).data('id'))

    $.ajax
      url: "business/applications/filter"
      type: 'get'
      dataType: 'script'
      data: {checked}

    


    


    
    




