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
  autoComplete = $('.autocomplete')
  autocompleteCustom = $('.autocompleteCustom')


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

  searchFieldDropDown = ->
    if (searchRequest)
      searchRequest.abort()
    action = $('#dropdown-autocomplete').attr('action')
    $.get(action, $('#dropdown-autocomplete').serialize(), null, "script") 

  searchAuto.on 'keyup', (event) ->
    clearTimeout debounceTimeout
    debounceTimeout = setTimeout(searchFieldAuto, 500)
    return

  searchInput.on 'click', (event) ->
    clearTimeout debounceTimeout
    debounceTimeout = setTimeout(searchEvents, 500)
    return

  searchText.on 'keyup', (event) ->
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

  submitLink = ->
    if (searchRequest)
      searchRequest.abort()
    $.post('/job_seeker/attachments', {link: $('#link-up').val()}, null, "script")

  $(document).on 'keyup', '#link-up', (event) ->
    if $(this).val().length > 3
      clearTimeout debounceTimeout
      debounceTimeout = setTimeout(submitLink, 500)
    return

  $(document).one 'click', '#client-action', (event) -> 
    searchAuto = $('.search-field-auto')
    linkUp = $('#link-up')
    searchRequest = null  
    debounceTimeout = null
    autocompleteCustom = $('.autocompleteCustom')

    searchFieldDropAuto = ->
      if (searchRequest)
        searchRequest.abort()
      action = $('#dropdown-autocomplete').attr('action')
      $.get(action, $('#dropdown-autocomplete').serialize(), null, "script") 

    searchAuto.on 'keyup', (event) ->
      clearTimeout debounceTimeout
      debounceTimeout = setTimeout(searchFieldDropAuto, 500)
      return

    customAutocomplete = (search) ->
      if (searchRequest)
        searchRequest.abort() 
      action = search.attr('id')
      $.get('/business/' + action + '/autocomplete', {term: search.val()}, null, "script")  

    $(document).on 'keyup', '.autocompleteCustom', (event) -> 
      clearTimeout debounceTimeout
      search = $(this)
      debounceTimeout = setTimeout(customAutocomplete, 500, search)
      return
    
    



  
    

  

