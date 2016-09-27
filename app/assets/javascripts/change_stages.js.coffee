$(window).load ->
  changeContainer = ($targetContainer) -> 
    $('.main-container').find('.showing').hide()
    $('.main-container').find('.showing').removeClass 'showing'
    $($targetContainer).show()
    $($targetContainer).addClass 'showing'

    return

  $('.job-stages').on 'click', 'li', (event) -> 
    val = $(this).attr('id')
    $('.not-present-container').show()

    $('.job-stages').find('.activated').removeClass 'activated'
    $(this).addClass 'activated'
      
    $(".table>tbody>tr").each ->   
      id = $(this).attr("id")    
      if id == val || val == 'all_applicants'
        $(this).show()
        $('.not-present-container').hide()
      else
        $(this).hide()

      return

  




