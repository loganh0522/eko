jQuery -> 
  $("#geocomplete").geocomplete({
    types: ['(cities)']
  })
  
  $("#geocomplete2").geocomplete()

  $('#find').click ->
    $('input').trigger 'geocode'
    return

