jQuery -> 
  $('.activity-filters').on 'click', '.checkbox', (event) ->

    if $(this).parent().attr('class') == 'open-job'
      val = "#{$(this).attr('data-id')}"

      if $(this).find('input').attr('value') == "true"
        $('.activity-feed').find("." + "#{val}").hide()
      else if $(this).find('input').attr('value') == "false"
        $('.activity-feed').find("." + "#{val}").show()


    if $(this).find('input').attr('value') == "true"
      $(this).find('input').attr('value', false)    
      
      if $(this).attr('data-id') == 'move stages'
        $('.activity-feed').find('.Application').hide()
      
      else if $(this).attr('data-id') == 'comments'
        $('.activity-feed').find('.Comment').hide()
      
      else if $(this).attr('data-id') == 'scorecards'
        $('.activity-feed').find('.ApplicationScorecard').hide()
      
      else if $(this).attr('data-id') == 'messages'
        $('.activity-feed').find('.Message').hide()


    else if $(this).find('input').attr('value') == "false"
      $(this).find('input').attr('value', true)   
      if $(this).attr('data-id') == 'move stages'
        $('.activity-feed').find('.Application').show()
      else if $(this).attr('data-id') == 'comments'
        $('.activity-feed').find('.Comment').show()
      else if $(this).attr('data-id') == 'scorecards'
        $('.activity-feed').find('.ApplicationScorecard').show()
      else if $(this).attr('data-id') == 'messages'
        $('.activity-feed').find('.Message').show()


    return



