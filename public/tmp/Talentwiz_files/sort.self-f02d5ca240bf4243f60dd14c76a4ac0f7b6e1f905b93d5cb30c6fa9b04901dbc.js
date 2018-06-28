(function() {
  jQuery(function() {
    $('#stages').sortable({
      axis: 'y',
      cursor: 'move',
      update: function() {
        return $.post($(this).data('update-url'), $(this).sortable('serialize'));
      }
    });
    $("#stages").disableSelection();
    $('#default-stages').sortable({
      axis: 'y',
      cursor: 'move',
      update: function() {
        return $.post($(this).data('update-url'), $(this).sortable('serialize'));
      }
    });
    $("#default-stages").disableSelection();
    $('#questions').sortable({
      axis: 'y',
      cursor: 'move',
      update: function() {
        return $.post($(this).data('update-url'), $(this).sortable('serialize'));
      }
    });
    $("#questions").disableSelection();
    $('#board-sections').sortable({
      axis: 'y',
      cursor: 'move',
      update: function() {
        return $.post($(this).data('update-url'), $(this).sortable('serialize'));
      }
    });
    $("#board-sections").disableSelection();
    return $(document).ajaxComplete(function() {
      return $('#nested-attributes, #scorecard-sections').sortable({
        axis: 'y',
        cursor: 'move',
        stop: function() {
          var numberElems;
          numberElems = $('.question-area').length;
          return $(this).find('.position').each(function(idx) {
            $(this).val(idx + 1);
          });
        }
      });
    });
  });

}).call(this);
