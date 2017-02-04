jQuery -> 
  changeContainer = ($targetContainer) -> 
    $('.applicant-profile-information').find('#showing-container').hide()
    $('.applicant-profile-information').find('#showing-container').removeAttr('id', 'showing-container') 
    
    $($targetContainer).show()
    $($targetContainer).attr('id', 'showing-container') 

    return

  $('.applicant-nav-bar').on 'click', 'li', (event) ->  
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

    $('.applicant-profile-information').find('.active-container').removeAttr('class', 'active-container')
    $(this).attr('class', 'active-container')

    changeContainer($targetContainer)
  
#################### Close Tag Form ######################
  $('.add_tag').on 'click', '.close-form', (event) ->
    console.log("clicked")
    $('#add_tag').show()
    $('.tag_form').remove()

