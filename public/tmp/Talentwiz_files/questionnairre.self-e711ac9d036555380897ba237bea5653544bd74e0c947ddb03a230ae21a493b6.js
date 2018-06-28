(function() {
  jQuery(function() {
    $(document).on('click', '.remove_kit_question', function(event) {
      $(this).nextAll('input[type=hidden]').val('1');
      return $(this).parent().parent().parent().hide();
    });
    $('.main-container').on('click', '.remove_question', function(event) {
      $(this).nextAll('input[type=hidden]').val('1');
      $(this).closest('fieldset').hide();
      $(this).parent().nextUntil('.questions').find('#destroy_fields').val('1');
      $(this).parent().closest('.scorecard-area').hide();
      return event.preventDefault();
    });
    $(document).ready(function() {
      if ($('.scorecard-area').length >= 2) {
        return $('.remove_question').show();
      }
    });
    $(document).on('click', '.question-answer-checkbox', function(event) {
      if ($(this).is(':checked')) {
        return $(this).next('input[type=hidden]').val('0');
      } else {
        return $(this).next('input[type=hidden]').val('1');
      }
    });
    $(document).on('change', '.question-type', function(event) {
      var add_fields, answers, regexp, time, val;
      val = $(this).children().val();
      if (val === "Select (One)" || val === "Multiselect") {
        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        add_fields = $(this).parent().next().find('.add_fields');
        add_fields.before(add_fields.data('fields'));
        add_fields.before(add_fields.data('fields'));
        return add_fields.parent().show();
      } else {
        answers = $(this).parent().next().find('.answers');
        answers.hide();
        answers.find('input[type=hidden]').val('1');
        return $(this).parent().next().find('.add_fields').hide();
      }
    });
    $(document).ready(function() {
      var i, len, regexp, results, time, val;
      val = $('form').find('.answer-type').find('.question-type');
      len = val.length;
      i = 0;
      results = [];
      while (i < len) {
        if ($(val[i]).val() === "Select" || $(val[i]).val() === "Multiselect") {
          time = new Date().getTime();
          regexp = new RegExp($(this).data('id'), 'g');
          $(val[i]).parent().parent().nextAll('.add_fields').show();
          event.preventDefault();
        } else {
          $(val[i]).parent().parent().nextAll('.add_fields').hide();
          event.preventDefault();
        }
        results.push(i++);
      }
      return results;
    });
    $(document).ready(function() {
      if ($('.add-work-experience').length >= 1) {
        return $('.remove_fields:not(:first)').show();
      }
    });
    $('.main-container').on('click', '.remove_fields', function(event) {
      $(this).nextAll('input[type=hidden]').val('1');
      $(this).parent().parent().hide();
      return event.preventDefault();
    });
    $('.create-profile-container').on('click', '.remove_fields', function(event) {
      $(this).first().prev().val('1');
      $(this).parent().parent().hide();
      return event.preventDefault();
    });
    $(document).on('click', '.add_fields_after', function(event) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).after($(this).data('fields').replace(regexp, time));
      $(this).prev().find('.remove_fields').show();
      return event.preventDefault();
    });
    $(document).on('click', '.remove_fields', function(event) {
      $(this).nextAll('input[type=hidden]').val('1');
      $(this).parent().parent().hide();
      return event.preventDefault();
    });
    $('.mediumModal, .largeModal').on('click', '.remove_question', function(event) {
      $(this).nextAll('input[type=hidden]').val('1');
      $(this).closest('fieldset').hide();
      $(this).parent().nextUntil('.questions').find('#destroy_fields').val('1');
      $(this).parent().closest('.scorecard-area').hide();
      return event.preventDefault();
    });
    return $('.mediumModal, .largeModal').on('click', '.remove_fields', function(event) {
      $(this).nextAll('input[type=hidden]').val('1');
      $(this).parent().parent().hide();
      return event.preventDefault();
    });
  });

}).call(this);
