jQuery ->
  $('.new_user_avatar').fileupload()
  $('#media-photo-up').fileupload()
  $('#background-photo-up').fileupload()
  
  $('#job-seeker-background-up').fileupload()
  
  $(".main-container").on 'click', "#submit-section", -> 
    $("#job-board-section").submit()

  $(document).ajaxComplete -> 
    $('.new_resume').fileupload()
    $('#media-photo-up').fileupload()
    $('#background-photo-up').fileupload()