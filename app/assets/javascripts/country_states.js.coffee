jQuery ->
  $(document).ajaxComplete ->    
    if $('form').find('#work_experience_country_ids').find(':selected').text() == "Select a Country"
      $('form').find('#work_experience_state_ids').parent().hide()
      $('form').find('#work_experience_city').parent().hide()
    else
      $('form').find('#work_experience_state_ids').parent().show()
      $('form').find('#work_experience_city').parent().show()

    states = $('#work_experience_state_ids').html()
    
    $('#work_experience_country_ids').change ->
      country = $('#work_experience_country_ids :selected').text()
      escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      options = $(states).filter("optgroup[label='#{escaped_country}']").html()
      if options
        $('#work_experience_state_ids').html(options)
        $('#work_experience_state_ids').parent().show()
        $('#work_experience_city').parent().show()
      else
        $('#work_experience_state_ids').empty()
        $('#work_experience_state_ids').parent().hide()
        $('#work_experience_city').parent().show()
  return

jQuery ->
  if $('#job_country_ids').find(':selected').text() == "Select a Country"
    $('#job_state_ids').parent().hide()
    $('#job_city').parent().hide()
  else
    $('#job_state_ids').parent().show()
    $('#job_city').parent().show()
  
  states = $('#job_state_ids').html()
  
  $('#job_country_ids').change ->
    country = $('#job_country_ids :selected').text()
    escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(states).filter("optgroup[label='#{escaped_country}']").html()
    if options
      $('#job_state_ids').html(options)
      $('#job_state_ids').parent().show()
      $('#job_city').parent().show()
    else
      $('#job_state_ids').empty()
      $('#job_state_ids').parent().hide()
      $('#job_city').parent().show()

