$(window).load ->
  totalWidth = 0 
  
  $('.job_list_stage').each ->
    totalWidth = totalWidth + $(this).outerWidth(true)
    return

  maxScrollPosition = totalWidth - $(".job-area").outerWidth()

  toGalleryItem = ($targetItem) ->
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
  
  $('.job-gallery').each -> 
    $(this).find('.job_list_stage:first').addClass 'job_list_stage_active'

  $('.left-scroll').click ->  
    $targetItem = $(this).parent().find('.job_list_stage_active').prev()
    toGalleryItem $targetItem
    return

  $('.right-scroll').click ->
    $targetItem = $(this).parent().find('.job_list_stage_active').next()
    toGalleryItem $targetItem
    return

  


