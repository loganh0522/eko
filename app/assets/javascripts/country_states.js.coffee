jQuery ->
  $('#work_experience_state_ids').parent().hide()
  $('#work_experience_city').parent().hide()
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

jQuery ->
  $('#job_state_ids').parent().hide()
  $('#job_city').parent().hide()
  
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