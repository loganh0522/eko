jQuery -> 

  changeContainer = ($targetContainer) -> 
    $('.active-tab').hide()
    $('.active-tab').removeClass 'active-tab'
    $($targetContainer).show()
    $($targetContainer).addClass 'active-tab'

    return


  $('.job-applicants-nav').on 'click', 'li', (event) -> 
    if $(this).attr('class') == 'applicants-tab'
      $targetContainer = '#job-applicants'
    else if $(this).attr('class') == 'activity-tab'
      $targetContainer = '#job-activity-container'
    else if $(this).attr('class') == 'calendar-tab'
      $targetContainer = '#calendar-container'


    $('.job-applicants-nav').find('.activated').css border: ''
    $('.job-applicants-nav').find('.activated').removeClass 'activated'
    
    
    $(this).addClass 'activated'

    changeContainer $targetContainer
    return