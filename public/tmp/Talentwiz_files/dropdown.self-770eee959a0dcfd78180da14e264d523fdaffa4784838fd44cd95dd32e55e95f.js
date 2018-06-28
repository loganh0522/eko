(function() {
  jQuery(function() {
    $(document).on('click', '.dropdown-button', function(e) {
      $(this).next('.dropdown-content').show();
      return e.stopPropagation();
    });
    $(document).on('click', '.dropdown-content', function(e) {
      return e.stopPropagation();
    });
    $(document).click(function(e) {
      $('.dropdown-content').hide();
    });
    $(document).on('click', '.select-item', function(e) {
      var elementId;
      elementId = $(this).data('id');
      $(this).nextAll('#select-box-field').val(elementId);
      $(this).parent().parent().hide();
      $(this).parent().parent().prev().find('.plain-text').html($(this).html() + '<span class="caret"></span>');
      return e.stopPropagation();
    });
    $(document).on('click', '.show-hidden-search-box', function(e) {
      $(this).next('.hidden-search-box').show();
      return e.stopPropagation();
    });
    $(document).on('click', '.hidden-search-box', function(e) {
      return e.stopPropagation();
    });
    $(document).on('click', '#multiple-users', function(e) {
      return e.stopPropagation();
    });
    return $(document).click(function(e) {
      $('.hidden-search-box').hide();
    });
  });

}).call(this);
