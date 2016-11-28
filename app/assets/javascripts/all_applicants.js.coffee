jQuery ->   
  $('.nav-header').on 'click', '.filter', (event) -> 
    if $(this).attr('class') == 'filter open-jobs'
      if $('.open-job-body').hasClass('showing') 
        $('.open-job-body').hide()
        $('.open-job-body').removeClass('showing')
      else 
        $('.open-job-body').show()
        $('.open-job-body').addClass('showing')
      return
    else if $(this).attr('class') == 'filter job-status'
      if $('.job-status-body').hasClass('showing') 
        $('.job-status-body').hide()
        $('.job-status-body').removeClass('showing')
      else 
        $('.job-status-body').show()
        $('.job-status-body').addClass('showing')
      return    
    else if $(this).attr('class') == 'filter date-applied'
      if $('.date-applied-body').hasClass('showing') 
        $('.date-applied-body').hide()
        $('.date-applied-body').removeClass('showing')
      else 
        $('.date-applied-body').show()
        $('.date-applied-body').addClass('showing')
      return
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

    


    


    
    




