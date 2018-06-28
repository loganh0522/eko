(function() {
  jQuery(function() {
    $('#media-photo-up').fileupload();
    $('#background-photo-up').fileupload();
    $('#job-seeker-background-up').fileupload();
    return $(document).ajaxComplete(function() {
      $('#media-photo-up').fileupload();
      return $('.new_resume').fileupload();
    });
  });

}).call(this);
