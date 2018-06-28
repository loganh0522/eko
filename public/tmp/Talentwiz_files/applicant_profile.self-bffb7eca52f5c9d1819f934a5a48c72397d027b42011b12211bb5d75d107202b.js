(function() {
  jQuery(function() {
    $('#embedURL').gdocsViewer({
      width: '400',
      height: '500'
    });
    $('a[data-popup]').on('click', function(e) {
      window.open($(this).attr('href'));
      e.preventDefault();
    });
    $('#main-container').on('click', '.applicant-checkbox', function(event) {
      if ($('.applicants').find('.applicant-checkbox :checked').size() > 0) {
        $('.no-action-buttons').hide();
        $('.applicant-action-buttons').show();
      } else if ($('.applicants').find('.applicant-checkbox :checked').size() === 0) {
        $('.applicant-action-buttons').hide();
        $('.no-action-buttons').show();
      }
    });
    $('#main-container').on('click', '#Select_All', function(event) {
      if ($('#select_all :checked').size() > 0) {
        $('.checkbox').prop("checked", true);
        $('.no-action-buttons').hide();
        $('.applicant-action-buttons').show();
      } else if ($('#select_all :checked').size() === 0) {
        $('.checkbox').prop("checked", false);
        $('.applicant-action-buttons').hide();
        $('.no-action-buttons').show();
      }
    });
    $(document).on('click', '.interview-type', function(event) {
      if ($(this).attr('id') === 'in-person') {
        return $('#interview-location').show();
      } else {
        return $('#interview-location').hide();
      }
    });
    $('#add-certification').on('click', '.add_fields', function(event) {
      return $('.not-present-container').hide();
    });
    $("#geocomplete").geocomplete({
      types: ['(cities)']
    });
    $("#geocomplete2").geocomplete();
    $(document).ajaxComplete(function() {
      $('.work-experience').find('#geocomplete').geocomplete({
        types: ['(cities)']
      });
      $('#geocomplete').geocomplete({
        types: ['(cities)']
      });
      $("#geocomplete2").geocomplete();
      return;
      return $("#geocomplete-address").geocomplete({
        types: ['(address)']
      });
    });
    $('#main-container').on('click', '.close-form', function(event) {
      var buttonobj, formobj;
      if ($(this).attr('id') === 'edit-form') {
        formobj = $(this).parent().attr('id').slice(5);
        $("#" + ("" + formobj)).show();
        $(this).parent().parent().remove();
      } else if ($(this).attr('id') === 'new-form') {
        buttonobj = $(this).parent().attr('id');
        $("#" + ("" + buttonobj) + "_button").show();
        $(this).parent().parent().remove();
      }
    });
    $('#main-container').on('click', '.star', function(event) {
      var PostCode, Rating;
      PostCode = $(this).parent().parent().attr('id');
      Rating = $(this).val();
      return $.ajax({
        url: "/business/candidates/" + PostCode + "/ratings",
        type: "post",
        data: {
          candidate_id: PostCode,
          rating: Rating
        }
      });
    });
    $(document).on('click', '.responsive-menu', function(event) {
      if ($('.responsive-menu-links').is(':visible')) {
        return $('.responsive-menu-links').hide();
      } else {
        return $('.responsive-menu-links').show();
      }
    });
    $(document).on('click', '.toggle', function(event) {
      if ($(this).hasClass('fa-angle-down')) {
        $(this).parent().next().show();
        $(this).parent().append("<i class='fa fa-angle-up toggle'></i>");
        return $(this).remove();
      } else if ($(this).hasClass('fa-angle-up')) {
        $(this).parent().next().hide();
        $(this).parent().append("<i class='fa fa-angle-down toggle'></i>");
        return $(this).remove();
      }
    });
    $(window).on("resize", function(event) {
      if ($(this).width() > 780) {
        return $('.responsive-menu-links').hide();
      }
    });
    $(document).on('click', '#work_experience_current_position', function(event) {
      if ($(this).is(':checked') === true) {
        $('#work_experience_end_month').hide();
        return $('#work_experience_end_year').hide();
      } else {
        $('#work_experience_end_month').show();
        return $('#work_experience_end_year').show();
      }
    });
    $(document).on('click', '.edit-position', function(event) {
      if ($('#work_experience_current_position').is(':checked') === true) {
        $('#work_experience_end_month').hide();
        return $('#work_experience_end_year').hide();
      } else {
        $('#work_experience_end_month').show();
        return $('#work_experience_end_year').show();
      }
    });
    $(document).on('keyup', '.number-only', function(event) {
      if ($.isNumeric($(this).val()) === false) {
        this.value = this.value.slice(0, -1);
      }
    });
    $(document).on('click', '.insert-token', function(event) {
      var element;
      element = document.querySelector("trix-editor");
      if ($(this).attr('id') === "first-name") {
        element.editor.insertHTML("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.first_name}} </span>");
      } else if ($(this).attr('id') === "last-name") {
        element.editor.insertHTML("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.last_name}} </span>");
      } else if ($(this).attr('id') === "full-name") {
        element.editor.insertHTML("<span contentEditable= 'false' class='class_one' style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.full_name}} </span>");
      } else if ($(this).attr('id') === "job-title") {
        element.editor.insertHTML("<span contentEditable= 'false' class='class_one' style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{job.title}} </span>");
      } else if ($(this).attr('id') === "company-name") {
        element.editor.insertHTML("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{company.name}} </span>");
      }
      return $(this).parent().parent().hide();
    });
    $(document).on('click', '.remove-main-form', function(e) {
      $('.main-form-container').remove();
      return $('.main-container').show();
    });
    return $('.form-radios').on('click', '.interview-kit-filter', function(event) {
      if ($(this).attr('id') === 'questions') {
        $('.questions-container').show();
        $('.overview-container').hide();
        $('.scorecard-container').hide();
        $('.interview-kit-filter').removeClass('active');
        $(this).addClass('active');
      } else if ($(this).attr('id') === 'scorecard') {
        $('.questions-container').hide();
        $('.overview-container').hide();
        $('.scorecard-container').show();
        $('.interview-kit-filter').removeClass('active');
        $(this).addClass('active');
      } else {
        $('.scorecard-container').hide();
        $('.questions-container').hide();
        $('.overview-container').show();
        $('.interview-kit-filter').removeClass('active');
        $(this).addClass('active');
      }
    });
  });

}).call(this);
