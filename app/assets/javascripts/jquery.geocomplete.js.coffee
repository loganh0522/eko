jQuery -> 
  $("#geocomplete").geocomplete({
    types: ['(cities)']
  })
  
  $("#geocomplete2").geocomplete()


  $('#interview-modal').on 'shown.bs.modal', ->
    $("#geocomplete2").geocomplete()

    $('#find').click ->
      $('input').trigger 'geocode'
      return

  $('#find').click ->
    $('input').trigger 'geocode'
    return

