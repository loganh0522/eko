(function() {
  jQuery(function() {
    $('#main-container').on('click', '.add_to_cart', function(event) {
      var board, regexp, subTotal, taxAmount, time, totalAmount;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      board = $(this).data('board');
      if ($("#order_" + board).length === 0) {
        $('#cart').find('.body').append($(this).data('fields').replace(regexp, time));
        $('.no-content').hide();
        subTotal = 0;
        $('.unit-price').each(function() {
          return subTotal += Number($(this).val());
        });
        taxAmount = Number(subTotal * 0.13).toFixed(2);
        totalAmount = Number(subTotal) + Number(taxAmount);
        $('#sub-total').find('.amount').html("$" + subTotal);
        $('#tax-total').find('.amount').html("$" + taxAmount);
        $('#cart-total').find('.amount').html("$" + totalAmount);
        $('#order_total').val(totalAmount);
      } else if ($("#order_" + board).length === 1) {
        $("#order_" + board).remove();
        $('.no-content').hide();
        $('#cart').find('.body').append($(this).data('fields').replace(regexp, time));
        subTotal = 0;
        $('.unit-price').each(function() {
          return subTotal += Number($(this).val());
        });
        taxAmount = Number(subTotal * 0.13).toFixed(2);
        totalAmount = Number(subTotal) + Number(taxAmount);
        $('#sub-total').find('.amount').html("$" + subTotal);
        $('#tax-total').find('.amount').html("$" + taxAmount);
        $('#cart-total').find('.amount').html("$" + totalAmount);
        $('#order_total').val(totalAmount);
      }
      return event.preventDefault();
    });
    return $('#main-container').on('click', '.remove_from_cart', function(event) {
      var id, subTotal, taxAmount, totalAmount;
      $(this).next('input[type=hidden]').val('1');
      id = $(this).parent().attr('id');
      $(this).closest('fieldset').remove();
      subTotal = Number($('#sub-total').find('.amount').val());
      $('.unit-price').each(function() {
        return subTotal += Number($(this).val());
      });
      $('#sub-total').find('.amount').html("$" + subTotal);
      taxAmount = Number(subTotal * 0.13).toFixed(2);
      totalAmount = Number(subTotal) + Number(taxAmount);
      $('#tax-total').find('.amount').html("$" + taxAmount);
      $('#cart-total').find('.amount').html("$" + totalAmount);
      $('#order_total').val(totalAmount);
      if (totalAmount === 0) {
        $('.no-content').show();
      }
      return event.preventDefault();
    });
  });

}).call(this);
