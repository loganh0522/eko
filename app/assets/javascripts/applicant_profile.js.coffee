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

  changeAction = ($targetContainer) -> 
    $('.applicant-main-top').find('#showing-action').hide()
    console.log($('.applicant-main-top').find('#showing-action'))
    $('.applicant-main-top').find('#showing-action').removeAttr('id', 'showing-action') 
    
    $($targetContainer).show()
    $($targetContainer).attr('id', 'showing-action') 
    return

  $('.application-actions').on 'click', '.btn-application-actions', (event) -> 
    if $(this).attr('id') == 'add-note'
      $targetContainer = '.comment-area'
    else if $(this).attr('id') == 'send-email'
      $targetContainer = '.email-area'

    $('.application-actions').find('.active-button').addClass('inactive-button').removeClass('active-button')
    $(this).addClass('active-button').removeClass('inactive-button')
    changeAction($targetContainer)
    return

  $('#move-applicant-stages').change -> 
    $.ajax
      url : "/business/applications/change_stage"
      type : "post"
      data:
        stage: $('#move-applicant-stages :selected').data('id')
        application: $('#move-applicant-stages :selected').data('application')

  
  
#################### Close Tag Form ######################
  $('.add_tag').on 'click', '.close-form', (event) ->
    $('#add_tag').show()
    $('.tag_form').remove()

