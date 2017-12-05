jQuery ->
  $('.new_user_avatar').fileupload()
  $('#media-photo-up').fileupload()
  $('#background-photo-up').fileupload()
  
  $('#job-seeker-background-up').fileupload()
  
  $(".main-container").on 'click', "#submit-section", -> 
    $("#job-board-section").submit()

  $('#userProfilePictureModal').on 'click', (event) -> 
    $('#new_user_avatar').fileupload()

  $(document).ajaxComplete -> 
    $('.new_resume').fileupload()
    $('#media-photo-up').fileupload()
    $('#background-photo-up').fileupload()

    
    $('#attachment-up').fileupload(
      type: 'POST'
      url: '/job_seeker/attachments'
      autoUpload: true
      )

    