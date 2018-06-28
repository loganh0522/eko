(function() {
  jQuery(function() {
    var GalleryItem, changeContainer, maxScrollPosition, totalWidth;
    changeContainer = function($targetContainer) {
      $('.main-container').find('.showing').hide();
      $('.main-container').find('.showing').removeClass('showing');
      $($targetContainer).show();
      $($targetContainer).addClass('showing');
    };
    $('.job-stages').on('click', 'li', function(event) {
      var hired, job, rejected, stage;
      $('.job-stages').find('.activated').removeClass('activated');
      $(this).addClass('activated');
      stage = $(this).data('stage');
      job = $(this).data('job');
      rejected = $(this).data('rejected');
      hired = $(this).data('hired');
      return $.ajax({
        url: '/business/applications/search',
        type: 'GET',
        data: {
          stage_id: stage,
          job_id: job,
          rejected: rejected,
          hired: hired
        }
      });
    });
    totalWidth = 0;
    $('.job_list_stage').each(function() {
      totalWidth = totalWidth + $(this).outerWidth(true);
    });
    maxScrollPosition = totalWidth - $(".job-area").outerWidth();
    GalleryItem = function($targetItem) {
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
    $('.job-gallery').find('.job_list_stage:first').addClass('job_list_stage_active');
    $('.left_scroll').click(function() {
      var $targetItem;
      $targetItem = $(this).parent().find('.job_list_stage_active').prev();
      GalleryItem($targetItem);
    });
    return $('.right_scroll').click(function() {
      var $targetItem;
      $targetItem = $(this).parent().find('.job_list_stage_active').next();
      GalleryItem($targetItem);
      console.log(totalWidth);
    });
  });

}).call(this);
