jQuery ->
  $(document).on 'click', '.dropdown-button', (e) ->
    $(this).next('.dropdown-content').show()
    e.stopPropagation()
  
  $(document).on 'click', '.dropdown-content', (e) -> 
    e.stopPropagation()
  
  $(document).click (e) -> 
    $('.dropdown-content').hide()
    return

  $(document).on 'click', '.select-item', (e) -> 
    elementId = $(this).data('id')
    $(this).nextAll('#select-box-field').val(elementId)
    $(this).parent().parent().hide()
    $(this).parent().parent().prev().find('.plain-text').html($(this).html() + '<span class="caret"></span>')
    e.stopPropagation()

  $(document).on 'click', '.show-hidden-search-box', (e) ->
    $(this).next('.hidden-search-box').show()
    e.stopPropagation()

  $(document).on 'click', '.hidden-search-box', (e) -> 
    e.stopPropagation()

  $(document).on 'click', '#multiple-users', (e) -> 
    e.stopPropagation()

  $(document).click (e) -> 
    $('.hidden-search-box').hide()
    return
