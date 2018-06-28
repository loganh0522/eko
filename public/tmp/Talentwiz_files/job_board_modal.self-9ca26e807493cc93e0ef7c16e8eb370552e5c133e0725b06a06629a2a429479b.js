(function() {
  jQuery(function() {
    return $(document).one('click', '.add-job-board-sections', function(event) {
      $(document).on('click', "#submit-section", function(event) {
        return $("#job-board-section").submit();
      });
      $(document).on('click', '#layout-form', function(event) {
        $('.job-board-form').hide();
        $('.job-board-layout').show();
        $('#jobBoardRowModal').find('.active').removeClass('.active');
        return $(this).addClass('.active');
      });
      return $(document).on('click', '#content-form', function(event) {
        $('.job-board-form').show();
        $('.job-board-layout').hide();
        $('#jobBoardRowModal').find('.active').removeClass('.active');
        return $(this).addClass('.active');
      });
    });
  });

}).call(this);
