jQuery ->
  $('#search-form').on 'click', '.filter', (event) ->
    console.log('clicked')
    action = $("#search-form").attr('action')
    param = $(this).attr('name') + "=" + $(this).attr('value')
    url = window.location
    $.get(action, $("#search-form").serialize(), null, "script")
    history.pushState({}, "", "?" + $("#search-form").serialize())
  
  $('#search-form').on 'keyup', '.search-field', (event) ->
    action = $("#search-form").attr('action')
    param = $(this).attr('name') + "=" 
    url = window.location
    $.get(action, $("#search-form").serialize(), null, "script")
    history.pushState({}, "", "?" + $("#search-form").serialize())

  $(".change-containers-nav").on 'click', '.change-aj', (event) ->
    $.getScript(this.href)
    history.pushState(null, "", this.href)
  
  $(window).bind 'popstate', ->
    $.getScript location.url
    return
  
