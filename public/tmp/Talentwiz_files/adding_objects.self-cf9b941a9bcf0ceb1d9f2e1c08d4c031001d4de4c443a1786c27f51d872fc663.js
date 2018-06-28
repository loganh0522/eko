(function() {
  jQuery(function() {
    $(document).on('click', '#delete-tag', function(event) {
      var count, field, index, objId, removeClass, values;
      removeClass = $(this).attr('class');
      objId = $(this).parent().data('id');
      field = $(document).find('#' + removeClass);
      values = field.val().split(',');
      index = $.inArray(objId, values);
      values.splice(index, 1);
      field.val(values);
      $(this).parent().remove();
      count = field.val().split(',').length;
      if (field.val() === '') {
        $('.newModal').hide();
        $('.newModal').find('form').remove();
      } else {
        $('.to').find('.dropdown-button').html('<div class="dropdown-button color="black">' + count + ' Candidates Selected <div class="caret"></div> </div>');
      }
    });
    $(document).on('click', '#delete-single', function() {
      var kind;
      kind = $(this).parent().attr('id');
      $(this).parent().prev().show();
      $(this).parent().remove();
      $('#candidate_id').val('');
    });
    return $(document).one('click', '#client-action', function(event) {
      $(document).on('click', '.user, .candidate', function(event) {
        var appendTo, kind, name, uType, value, values;
        name = $(this).find('.name').text();
        kind = $(this).data('kind');
        value = $(this).data('id');
        uType = kind + "_" + value;
        appendTo = $(this).parent().parent().prev().find('#multiple-users');
        if ($(this).parent().attr('id') === 'add-multiple') {
          if ($('#' + kind + '_ids').val() === '') {
            $('#' + kind + '_ids').val(value);
          } else {
            values = $('#' + kind + '_ids').val() + ',' + value;
            $('#' + kind + '_ids').val(values);
          }
          $(appendTo).append('<div class="user-tag" id="' + uType + '"> <div class="name">' + name + '</div> <div class="delete-tag" id="delete-multiple"> &times </div> </div>');
          $('.hidden-search-box').hide();
        } else if ($(this).parent().attr('id') === 'add-single') {
          $('#' + kind + '_id').val($(this).data('id'));
          $(this).parent().parent().prev().find('#single-obj').before('<div class="user-tag"> <div class="name">' + name + '</div> <div class="delete-tag" id="delete-single"> &times </div> </div>');
          $(this).parent().parent().prev().find('.plain-text').hide();
          $('.hidden-search-box').hide();
        }
      });
      $(document).on('click', '#delete-multiple', function() {
        var index, kind, value, values;
        kind = $(this).parent().attr('id').split('_')[0];
        value = $(this).parent().attr('id').split('_')[1];
        values = $('#' + kind + '_ids').val().split(',');
        index = values.indexOf(value);
        values.splice(index, 1);
        $('#' + kind + '_ids').val(values);
        $(this).parent().remove();
      });
      return $(document).on('click', '#delete-single', function() {
        var kind;
        kind = $(this).parent().attr('id');
        $(this).parent().prev().show();
        $(this).parent().remove();
        $('#candidate_id').val('');
      });
    });
  });

}).call(this);
