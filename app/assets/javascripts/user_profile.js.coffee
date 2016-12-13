jQuery -> 
  $('.active').css color: 'rgb(239, 122, 43)'

  changeContainer = ($targetContainer) -> 
    $('.main-container').find('#showing').hide()
    $('.main-container').find('#showing').removeAttr('id', 'showing') 
    $($targetContainer).show()
    $($targetContainer).attr('id', 'showing') 

    return

  $('.user-profile-nav').on 'click', 'li', (event) -> 
    if $(this).attr('class') == 'experience-tab'
      $targetContainer = '.experience-container'
      $('.new_experience').show()
    else if $(this).attr('class') == 'education-tab'
      $targetContainer = '.education-container'
      $('.new_experience').show()
    else if $(this).attr('class') == 'skills-tab'
      $targetContainer = '.skills-container'
      $('.new_experience').show()
    else if $(this).attr('class') == 'career-prefs-tab'
      $targetContainer = '.career-prefs-container'
      $('.new_experience').show()
    else if $(this).attr('class') == 'my-apps-tab'
      $targetContainer = '.my-apps-container'
      $('.new_experience').show()
  
    $('.user-profile-nav').find('.active').css color: 'black'
    $('.user-profile-nav').find('.active').removeClass 'active'
    
    
    $(this).addClass 'active'
    $(this).css color: 'rgb(239, 122, 43)'

    changeContainer $targetContainer
    return


  $(document).on('click', '.add-accomplishment', ( ->
    exp = $(this).data('id')
    $("#accomplishment_work_experience_id").val(exp)
    ));


  $(document).on('click', '.close-form', ( ->
    formobj = $('.profile-form').attr('id').slice(5)
    console.log(formobj)

    if $(this).attr('id') == 'new-form'
      $(this).parent().parent().remove()
      $('.new_experience').show()
    else if $(this).attr('id') == 'edit-form'
      $(this).parent().parent().remove()
      $('.body').find("#" + "#{formobj}").show()
    return

  ));


  $(document).ajaxComplete ->
    if $('#work_experience_current_position').prop('checked') == true
      $('#work_experience_end_month').hide()
      $('#work_experience_end_month').parent().hide()
      $('#work_experience_end_year').hide()
      $('#work_experience_end_year').parent().hide()
    else if $('#work_experience_current_position').prop('checked') == false
      $('#work_experience_end_month').show()
      $('#work_experience_end_month').parent().show()
      $('#work_experience_end_year').show()
      $('#work_experience_end_year').parent().show()

    return



  $(document).on('click', '#work_experience_current_position', ( ->
    console.log($('#work_experience_current_position').prop('checked'))
    if $('#work_experience_current_position').prop('checked') == true
      $('#work_experience_end_month').hide()
      $('#work_experience_end_month').parent().hide()
      $('#work_experience_end_year').hide()
      $('#work_experience_end_year').parent().hide()
    else if $('#work_experience_current_position').prop('checked') == false
      $('#work_experience_end_month').show()
      $('#work_experience_end_month').parent().show()
      $('#work_experience_end_year').show()
      $('#work_experience_end_year').parent().show()

    return
  ));




  


  


    






    

    