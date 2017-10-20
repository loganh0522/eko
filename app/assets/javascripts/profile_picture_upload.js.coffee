jQuery ->
  $('.new_user_avatar').fileupload()
  
  $(document).ajaxComplete -> 
    $('.new_resume').fileupload()
  