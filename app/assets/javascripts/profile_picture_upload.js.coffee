jQuery ->
  $('.new_user_avatar').fileupload()
  $('#media-photo-up').fileupload()
  $('#background-photo-up').fileupload()  
  $('#job-seeker-background-up').fileupload()

  
  

  $(document).ajaxComplete -> 
    $('#media-photo-up').fileupload();
    $('#background-photo-up').fileupload();
    $('.new_resume').fileupload();

  $('#userProfilePictureModal').on 'click', (event) -> 
    $('#new_user_avatar').fileupload()

  
    
    