jQuery ->
  $('form').on 'focus', '#autocomplete', ->  
    controller = $(this).attr('class').split(' ').pop()
    $(this).autocomplete( 
      source: '/business/' + controller + '/autocomplete'
      appendTo: $('#search-results-' + controller)     
      focus: (event, ui) -> 
        if controller == "jobs"
          $('#search-results-' + controller).val ui.item.title
        else
          $('#search-results-' + controller).val ui.item.first_name + ui.item.last_name
        false
      select: (event, ui) ->
        idType = controller.slice(0, -1)
        if controller == "jobs"
          $('.assigned-' + controller).append('<div class="user-tag"> <div class="name">' + ui.item.title  + '</div> <div class="delete-tag"> &times </div> </div>') 
        else
          userId = ui.item.id
       
          $('.assigned-' + controller).append('<div class="user-tag" data-id=' + userId + ' data-kind="user"><div class="circle-img"><img src="/tmp/little-man.png"></div><div class="name">' + ui.item.full_name  + '</div> <div class="delete-tag"> &times </div> </div>') 

        if $('#' + idType + '_ids').val() == ''
          values = ui.item.id
        else
          values =  $('#' + idType + '_ids').val() + ',' + ui.item.id
        $('#' + idType + '_ids').val values  
        false

    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      if controller == "jobs"
        $('<li>').attr('ui-item-autocomplete' , item.value).append("<a>" + item.title + "</a>").appendTo ul 
      else
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
    return
  return

$(document).ajaxComplete ->
  $('form').on 'focus', '#autocomplete', ->  
    controller = $(this).attr('class').split(' ').pop()
    $(this).autocomplete( 
      source: '/business/' + controller + '/autocomplete'
      appendTo: $('#search-results-' + controller)     
      focus: (event, ui) -> 
        if controller == "jobs"
          $('#search-results-' + controller).val ui.item.title
        else
          $('#search-results-' + controller).val ui.item.first_name + ui.item.last_name
        false
      select: (event, ui) ->
        idType = controller.slice(0, -1)
        if controller == "jobs"
          $('.assigned-' + controller).append('<div class="user-tag"> <div class="name">' + ui.item.title  + '</div> <div class="delete-tag"> &times </div> </div>') 
        else
          userId = ui.item.id
       
          $('.assigned-' + controller).append('<div class="user-tag" data-id=' + userId + ' data-kind="user"><div class="circle-img"><img src="/tmp/little-man.png"></div><div class="name">' + ui.item.full_name  + '</div> <div class="delete-tag"> &times </div> </div>') 

        if $('#' + idType + '_ids').val() == ''
          values = ui.item.id
        else
          values =  $('#' + idType + '_ids').val() + ',' + ui.item.id
        $('#' + idType + '_ids').val values  
        false

    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      if controller == "jobs"
        $('<li>').attr('ui-item-autocomplete' , item.value).append("<a>" + item.title + "</a>").appendTo ul 
      else
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
    return
  return



  




