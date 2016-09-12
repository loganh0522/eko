jQuery -> 
  $('.active').css color: 'rgb(239, 122, 43)'

  changeContainer = ($targetContainer) -> 
    $('.main-container').find('.showing').hide()
    $('.main-container').find('.showing').removeClass 'showing'
    $($targetContainer).show()
    $($targetContainer).addClass 'showing'

    return

  $('.user-profile-nav').on 'click', 'li', (event) -> 
    if $(this).attr('class') == 'experience-tab'
      $targetContainer = '.experience-container'
    else if $(this).attr('class') == 'education-tab'
      $targetContainer = '.education-container'
    else if $(this).attr('class') == 'skills-tab'
      $targetContainer = '.skills-container'
    else if $(this).attr('class') == 'career-prefs-tab'
      $targetContainer = '.career-prefs-container'
    else if $(this).attr('class') == 'my-apps-tab'
      $targetContainer = '.my-apps-container'
  
    $('.user-profile-nav').find('.active').css color: 'black'
    $('.user-profile-nav').find('.active').removeClass 'active'
    
    
    $(this).addClass 'active'
    $(this).css color: 'rgb(239, 122, 43)'

    console.log($targetContainer)
    changeContainer $targetContainer
    return




  $(document).on('click', '.add-accomplishment', ( ->
    exp = $(this).data('id')
    $("#accomplishment_work_experience_id").val(exp)
    ));



  $(document).on('click', '.close-form', ( ->
    formobj = $('form').attr('id').slice(5)
    console.log(formobj)

    if $(this).attr('id') == 'new-form'
      $(this).parent().parent().remove()
      $('.new_experience').show()
    else if $(this).attr('id') == 'edit-form'
      $(this).parent().parent().remove()
      $('.body').find("#" + "#{formobj}").show()
    return



  ));


  


    






    

    