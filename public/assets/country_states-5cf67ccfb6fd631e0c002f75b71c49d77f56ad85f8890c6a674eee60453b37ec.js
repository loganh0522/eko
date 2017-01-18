(function() {
  jQuery(function() {
    $(document).ajaxComplete(function() {
      var states;
      if ($('form').find('#work_experience_country_ids').find(':selected').text() === "Select a Country") {
        $('form').find('#work_experience_state_ids').parent().hide();
        $('form').find('#work_experience_city').parent().hide();
      } else {
        $('form').find('#work_experience_state_ids').parent().show();
        $('form').find('#work_experience_city').parent().show();
      }
      states = $('#work_experience_state_ids').html();
      return $('#work_experience_country_ids').change(function() {
        var country, escaped_country, options;
        country = $('#work_experience_country_ids :selected').text();
        escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
        options = $(states).filter("optgroup[label='" + escaped_country + "']").html();
        if (options) {
          $('#work_experience_state_ids').html(options);
          $('#work_experience_state_ids').parent().show();
          return $('#work_experience_city').parent().show();
        } else {
          $('#work_experience_state_ids').empty();
          $('#work_experience_state_ids').parent().hide();
          return $('#work_experience_city').parent().show();
        }
      });
    });
  });

  jQuery(function() {
    var states;
    if ($('#job_country_ids').find(':selected').text() === "Select a Country") {
      $('#job_state_ids').parent().hide();
      $('#job_city').parent().hide();
    } else {
      $('#job_state_ids').parent().show();
      $('#job_city').parent().show();
    }
    states = $('#job_state_ids').html();
    return $('#job_country_ids').change(function() {
      var country, escaped_country, options;
      country = $('#job_country_ids :selected').text();
      escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
      options = $(states).filter("optgroup[label='" + escaped_country + "']").html();
      if (options) {
        $('#job_state_ids').html(options);
        $('#job_state_ids').parent().show();
        return $('#job_city').parent().show();
      } else {
        $('#job_state_ids').empty();
        $('#job_state_ids').parent().hide();
        return $('#job_city').parent().show();
      }
    });
  });

}).call(this);
