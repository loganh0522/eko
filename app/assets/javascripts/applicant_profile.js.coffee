jQuery -> 
  changeContainer = ($targetContainer) -> 
    $('.applicant-main-container').find('#showing-container').hide()
    $('.applicant-main-container').find('#showing-container').removeAttr('id', 'showing-container') 
    
    $($targetContainer).show()
    $($targetContainer).attr('id', 'showing-container') 

    return

  $('.applicant-main-container').on 'click', 'li', (event) ->  
    if $(this).attr('id') == 'app-profile'
      $targetContainer = '.profile-container'
    else if $(this).attr('id') == 'app-messages'
      $targetContainer = '.messages-container'
    
    else if $(this).attr('id') == 'app-notes'
      $targetContainer = '.notes-container'
    
    else if $(this).attr('id') == 'app-assessments'
      $targetContainer = '.assessments-container'
    
    else if $(this).attr('id') == 'app-scorecards'
      $targetContainer = '.scorecards-container'

    else if $(this).attr('id') == 'app-activity'
      $targetContainer = '.activity-container'

    $('.applicant-main-container').find('.active-container').removeAttr('class', 'active-container')
    $(this).attr('class', 'active-container')

    changeContainer($targetContainer)
