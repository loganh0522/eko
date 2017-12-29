jQuery ->
  $('#main-container').on 'click', '.add_to_cart', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    
    board = $(this).data('board')
    if $("#order_" + board).length == 0 
      $('#cart').find('.body').append($(this).data('fields').replace(regexp, time))
      totalAmount = 0
      $('.unit-price').each -> 
        totalAmount += Number($(this).val())
      $('#cart-total').find('.amount').html("$" + totalAmount)
      $('#order_total').val(totalAmount)
    else if $("#order_" + board).length == 1 
      $("#order_" + board).remove()
      $('#cart').find('.body').append($(this).data('fields').replace(regexp, time))
      totalAmount = 0
      $('.unit-price').each -> 
        totalAmount += Number($(this).val())
      $('#cart-total').find('.amount').html("$" + totalAmount)
      $('#order_total').val(totalAmount)

    event.preventDefault()

  $('#main-container').on 'click', '.remove_from_cart', (event) ->
    $(this).next('input[type=hidden]').val('1')
    id = $(this).parent().attr('id')
    $(this).closest('fieldset').remove()

    totalAmount = Number($('#cart-total').find('.amount').val())

    $('.unit-price').each -> 
      totalAmount += Number($(this).val())

    $('#cart-total').find('.amount').html("$" + totalAmount)
    $('#order_total').val(totalAmount)
    event.preventDefault()