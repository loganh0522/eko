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
  
  totalWidth = 0 

  $('.job_list_stage').each ->
    totalWidth = totalWidth + $(this).outerWidth(true)
    return

  maxScrollPosition = totalWidth - $(".job-area").outerWidth()

  GalleryItem = ($targetItem) ->
    if $targetItem.length
      newPosition = $targetItem.position().left
      if newPosition <= maxScrollPosition
        $targetItem.addClass 'job_list_stage_active'
        $targetItem.siblings().removeClass('job_list_stage_active')
        $targetItem.parent('.job-gallery').animate left: -newPosition
      else
        $('.job-gallery').animate left: -maxScrollPosition
    return

  $('.job-gallery').width totalWidth
  
  $('.job-gallery').find('.job_list_stage:first').addClass 'job_list_stage_active'

  $('.left_scroll').click ->  
    $targetItem = $(this).parent().find('.job_list_stage_active').prev()
    GalleryItem $targetItem
    return

  $('.right_scroll').click ->
    $targetItem = $(this).parent().find('.job_list_stage_active').next()
    GalleryItem $targetItem
    console.log(totalWidth)
    return

$(document).ajaxComplete ->
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
  
  totalWidth = 0 

  $('.job_list_stage').each ->
    totalWidth = totalWidth + $(this).outerWidth(true)
    return

  maxScrollPosition = totalWidth - $(".job-area").outerWidth()

  GalleryItem = ($targetItem) ->
    if $targetItem.length
      newPosition = $targetItem.position().left
      if newPosition <= maxScrollPosition
        $targetItem.addClass 'job_list_stage_active'
        $targetItem.siblings().removeClass('job_list_stage_active')
        $targetItem.parent('.job-gallery').animate left: -newPosition
      else
        $('.job-gallery').animate left: -maxScrollPosition
    return

  $('.job-gallery').width totalWidth
  
  $('.job-gallery').find('.job_list_stage:first').addClass 'job_list_stage_active'

  $('.left_scroll').click ->  
    $targetItem = $(this).parent().find('.job_list_stage_active').prev()
    GalleryItem $targetItem
    return

  $('.right_scroll').click ->
    $targetItem = $(this).parent().find('.job_list_stage_active').next()
    GalleryItem $targetItem
    console.log(totalWidth)
    return
 




