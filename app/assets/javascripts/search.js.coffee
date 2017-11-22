jQuery ->
  if history and history.pushState
    $ ->
      $('#main-container').on 'click', '.pagination a', ->
        linkUrl = $(this).attr('href').split("?")[1]
        history.pushState({}, "", "?" + linkUrl)
        $.getScript(this.href)
        false
      $(window).bind 'popstate', ->
        $.getScript location.href
        return
      return

  searchRequest = null  
  debounceTimeout = null
  searchInput = $('.filter, input[name=\'owner\']')
  searchText = $('.search-field')
  searchAuto = $('.search-field-auto')

  searchEvents = -> 
    if (searchRequest)
      searchRequest.abort()
    
    action = $("#search-form").attr('action')
    param = $(this).attr('name') + "=" + $(this).attr('value')
    url = window.location
    links = $('.filter-link') 
    for n in links
      linkUrl = $(n).attr('href').split("?")[0]
      n.setAttribute('href', linkUrl + "?" + $("#search-form").serialize())
    searchRequest = $.get(action, $("#search-form").serialize(), null, "script")
    history.pushState({}, "", "?" + $("#search-form").serialize())
  
  searchField = ->
    if (searchRequest)
      searchRequest.abort()
    
    action = $("#search-form").attr('action')
    param = $(this).attr('name') + "=" 
    url = window.location
    links = $('.filter-link')
    
    for n in links
      linkUrl = $(n).attr('href').split("?")[0]
      n.setAttribute('href', linkUrl + "?" + $("#search-form").serialize())
    
    $.get(action, $("#search-form").serialize(), null, "script")  
    history.pushState({}, "", "?" + $("#search-form").serialize())

  searchFieldAuto = ->
    if (searchRequest)
      searchRequest.abort()
    action = $("#search-form").attr('action')
    $.get(action, $("#search-form").serialize(), null, "script") 

  searchAuto.on 'keyup', (event) ->
    clearTimeout debounceTimeout
    debounceTimeout = setTimeout(searchFieldAuto, 500)
    return

  searchInput.on 'click', (event) ->
    clearTimeout debounceTimeout
    debounceTimeout = setTimeout(searchEvents, 500)
    return

  searchText.on 'keyup', (event) ->
    console.log(searchText.val().length)
    clearTimeout debounceTimeout
    debounceTimeout = setTimeout(searchField, 500)
    return

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