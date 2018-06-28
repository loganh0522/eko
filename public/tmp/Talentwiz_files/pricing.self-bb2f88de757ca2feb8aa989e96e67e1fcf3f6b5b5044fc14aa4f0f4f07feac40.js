(function() {
  jQuery(function() {
    var changeContainer;
    changeContainer = function($targetContainer) {
      $('.pricing-table').find('.showing').hide();
      $('.pricing-table').find('.showing').removeClass('showing');
      $($targetContainer).show();
      $($targetContainer).addClass('showing');
    };
    return $('.pricing-type').on('click', 'li', function(event) {
      var $targetContainer;
      if ($(this).attr('class') === 'monthly-tab') {
        $targetContainer = '.monthly';
      } else if ($(this).attr('class') === 'yearly-tab') {
        $targetContainer = '.yearly';
      }
      $('.pricing-type').find('.active-price').css({
        background: 'white'
      });
      $('.pricing-type').find('.active-price').removeClass('active-price');
      $(this).addClass('active-price');
      $(this).css({
        background: 'rgb(239, 122, 43)'
      });
      changeContainer($targetContainer);
    });
  });

}).call(this);
