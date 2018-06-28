(function() {
  jQuery(function() {
    var modal;
    modal = document.getElementById('mediumModal');
    $(".close-modal").on('click', function(event) {
      return $('.newModal').hide();
    });
    window.onclick = function(event) {
      if (event.target === modal) {
        modal.style.display = 'none';
      }
    };
    return $(document).ajaxComplete(function() {
      return $(".close-modal").on('click', function(event) {
        return $('.newModal').hide();
      });
    });
  });

}).call(this);
