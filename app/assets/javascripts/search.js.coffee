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