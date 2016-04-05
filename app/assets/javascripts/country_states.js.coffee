jQuery ->
  $('#work_experience_state').parent().hide()
  $('#work_experience_city').parent().hide()
  states = $('#work_experience_state').html()
  $('#work_experience_country').change ->
    country = $('#work_experience_country :selected').text()
    escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(states).filter("optgroup[label='#{escaped_country}']").html()
    if options
      $('#work_experience_state').html(options)
      $('#work_experience_state').parent().show()
      $('#work_experience_city').parent().show()
    else
      $('#work_experience_state').empty()
      $('#work_experience_state').parent().hide()
      $('#work_experience_city').parent().show()

