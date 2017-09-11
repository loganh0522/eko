document.addEventListener 'turbolinks:load', ->
  $(document).ajaxComplete -> 
    $('.user_avatar_image').fileupload()

    
    
  