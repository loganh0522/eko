jQuery ->
  $('.new_user_avatar').fileupload()
  $('#media-photo-up').fileupload()
  $('#background-photo-up').fileupload()
  
  $('#job-seeker-background-up').fileupload()

  $('#userProfilePictureModal').on 'click', (event) -> 
    $('#new_user_avatar').fileupload()

  $(document).ajaxComplete -> 
    $('.new_resume').fileupload()
    $('#media-photo-up').fileupload()
    $('#background-photo-up').fileupload()

    
    