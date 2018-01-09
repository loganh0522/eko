jQuery -> 
  $(document).on 'click', '#delete-tag', (event) -> 
    removeClass = $(this).attr('class')
    objId = $(this).parent().data('id')
    field = $(document).find('#' + removeClass)
    values = field.val().split(',')
    index = $.inArray(objId, values)
    values.splice(index, 1)
    field.val(values)
    $(this).parent().remove()
    count = field.val().split(',').length

    if field.val() == ''
      $('.newModal').hide()
      $('.newModal').find('form').remove()
    else 
      $('.to').find('.dropdown-button').html('<div class="dropdown-button color="black">' + count + ' Candidates Selected <div class="caret"></div> </div>')
    return

  $(document).on 'click', '#delete-single', ->
    kind = $(this).parent().attr('id')
    $('.plain-text').show()
    $(this).parent().remove()
    $('#candidate_id').val('')
    return