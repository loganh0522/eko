(function() {
  jQuery(function() {
    var maxScrollPosition, toGalleryItem, totalWidth;
    totalWidth = 0;
    $('.job_list_stage').each(function() {
      totalWidth = totalWidth + $(this).outerWidth(true);
    });
    maxScrollPosition = totalWidth - $(".job-area").outerWidth();
    toGalleryItem = function($targetItem) {
      var newPosition;
      if ($targetItem.length) {
        newPosition = $targetItem.position().left;
        if (newPosition <= maxScrollPosition) {
          $targetItem.addClass('job_list_stage_active');
          $targetItem.siblings().removeClass('job_list_stage_active');
          $targetItem.parent('.job-gallery').animate({
            left: -newPosition
          });
        } else {
          $('.job-gallery').animate({
            left: -maxScrollPosition
          });
        }
      }
    };
    $('.job-gallery').width(totalWidth);
    $('.job-gallery').each(function() {
      return $(this).find('.job_list_stage:first').addClass('job_list_stage_active');
    });
    $('.left-scroll').click(function() {
      var $targetItem;
      $targetItem = $(this).parent().find('.job_list_stage_active').prev();
      toGalleryItem($targetItem);
    });
    return $('.right-scroll').click(function() {
      var $targetItem;
      $targetItem = $(this).parent().find('.job_list_stage_active').next();
      toGalleryItem($targetItem);
    });
  });

}).call(this);
