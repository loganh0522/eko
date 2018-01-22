jQuery ->
  $('#media-photo-up').fileupload()
  $('#background-photo-up').fileupload()  
  $('#job-seeker-background-up').fileupload()

  $(document).ajaxComplete -> 
    $('#media-photo-up').fileupload();
    $('#background-photo-up').fileupload();
    $('.new_resume').fileupload();

  

  
    
    