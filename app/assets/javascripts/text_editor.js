document.addEventListener 'turbolinks:load', ->
  $('.wysihtml5').each (i, elem) ->
    $(elem).wysihtml5()
    return
  return

