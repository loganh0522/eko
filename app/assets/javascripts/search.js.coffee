jQuery ->
  $('#search-form').on 'click', '.filter, input[name=\'owner\'] ', (event) ->
    action = $("#search-form").attr('action')
    param = $(this).attr('name') + "=" + $(this).attr('value')
    url = window.location
    links = $('.filter-link') 
    for n in links
      n.setAttribute('href', "?" + $("#search-form").serialize())
    $.get(action, $("#search-form").serialize(), null, "script")
    history.pushState({}, "", "?" + $("#search-form").serialize())
  
  $('#search-form').on 'keyup', '.search-field', (event) ->
    action = $("#search-form").attr('action')
    param = $(this).attr('name') + "=" 
    url = window.location
    links = $('.filter-link')
    for n in links
      n.setAttribute('href', "?" + $("#search-form").serialize())
    $.get(action, $("#search-form").serialize(), null, "script")
    history.pushState({}, "", "?" + $("#search-form").serialize())

  $(".change-containers-nav").on 'click', '.change-aj', (event) ->
    $.getScript(this.href)
    history.pushState(null, "", this.href)
  
  $(window).bind 'popstate', ->
    $.getScript location.url
    return

  $('form').on 'click', '#search-form', ->  
    controller = $(this).attr('class').split(' ').pop()  
    $(this).autocomplete( 
      source: '/business/' + controller 
      appendTo: $('#search-results')     
      focus: (event, ui) -> 
        if controller == "jobs"
          $('#search-results').val ui.item.title
        else
          $('#search-results').val ui.item.first_name + ui.item.last_name
        false
      select: (event, ui) ->
        idType = controller.slice(0, -1)
        if controller == "jobs"
          $('.assigned-' + controller).append('<div class="user-tag"> <div class="name">' + ui.item.title  + '</div> <div class="delete-tag"> &times </div> </div>') 
        else
          $('.assigned-' + controller).append('<div class="user-tag" > <div class="name">' + ui.item.full_name  + '</div> <div class="delete-tag"> &times </div> </div>')  
        
        if $('#' + idType + '_ids').val() == ''
          values = ui.item.id
        else
          values =  $('#' + idType + '_ids').val() + ',' + ui.item.id
        $('#' + idType + '_ids').val values
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      if controller == "jobs"
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.title + "</a>").appendTo ul 
      else
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul 
    return
    
  
  $('#main-container').on 'click', '.glyphicon', (event) ->
    if $(this).hasClass('glyphicon-minus')
      $(this).parent().next().hide()
      $(this).hide()
      $(this).next().show()
    else if $(this).hasClass('glyphicon-plus')
      $(this).parent().next().show()
      $(this).hide()
      $(this).prev().show()
    return