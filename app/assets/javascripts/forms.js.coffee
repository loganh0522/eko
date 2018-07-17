x = undefined
i = undefined
j = undefined
selElmnt = undefined
a = undefined
b = undefined
c = undefined

###look for any elements with the class "custom-select":###

listen = (el, event, handler) ->
  if el.addEventListener
    el.addEventListener event, handler
  else
    el.attachEvent 'on' + event, ->
      handler.call el

closeAllSelect = (elmnt) ->
  `var x`
  `var i`
  x = undefined
  y = undefined
  i = undefined
  arrNo = []
  x = document.getElementsByClassName('select-items')
  y = document.getElementsByClassName('select-selected')
  i = 0
  while i < y.length
    if elmnt == y[i]
      arrNo.push i
    else
      y[i].classList.remove 'select-arrow-active'
    i++
  i = 0
  while i < x.length
    if arrNo.indexOf(i)
      x[i].classList.add 'select-hide'
    i++
  return

createSelectMenu = (i, customSelects) ->
  while i < x.length
    selElmnt = x[i].getElementsByTagName('select')[0]
    console.log(selElmnt)
    ###for each element, create a new DIV that will act as the selected item:###
    
    if x[i].getElementsByClassName('select-items').length == 0
      a = document.createElement('DIV')
      a.setAttribute 'class', 'select-selected'
      a.innerHTML = selElmnt.options[selElmnt.selectedIndex].innerHTML
      x[i].appendChild a

      ###for each element, create a new DIV that will contain the option list:###

      b = document.createElement('DIV')
      b.setAttribute 'class', 'select-items select-hide'
      j = 1
      
      while j < selElmnt.length
        ###for each option in the original select element,
        create a new DIV that will act as an option item:
        ###
       

        c = document.createElement('div')
        c.innerHTML = selElmnt.options[j].innerHTML
        
        c.setAttribute('data-id', selElmnt.options[j].value) if selElmnt.options[j].value.length > 0 
        c.setAttribute('id', "change-subsidiary") if selElmnt.getAttribute('id') == 'subsidiary'
        

        c.addEventListener 'click', (e) ->
          `var i`

          ###when an item is clicked, update the original select box,
          and the selected item:
          ###

          y = undefined
          i = undefined
          k = undefined
          s = undefined
          h = undefined
          s = @parentNode.parentNode.getElementsByTagName('select')[0]
          h = @parentNode.previousSibling
          i = 0
          
          while i < s.length
            if s.options[i].innerHTML == @innerHTML
              s.selectedIndex = i
              h.innerHTML = @innerHTML
              y = @parentNode.getElementsByClassName('same-as-selected')
              k = 0
              while k < y.length
                y[k].removeAttribute 'class'
                k++
              @setAttribute 'class', 'same-as-selected'
              break
            i++
          h.click()
          return
        b.appendChild c
        j++

      x[i].appendChild b
    
    a.addEventListener 'click', (e) ->
      ###when the select box is clicked, close any other select boxes,
      and open/close the current select box:
      ###

      e.stopPropagation()
      closeAllSelect this
      @nextSibling.classList.toggle 'select-hide'
      @classList.toggle 'select-arrow-active'
      return
    i++

jQuery ->
  x = document.getElementsByClassName('custom-select')
  i = 0
  createSelectMenu(i, x)
  
  document.addEventListener 'click', closeAllSelect
  
  $('#subsidiary-admin-select').on 'click', '#change-subsidiary', -> 
    path = window.location.pathname
    $.ajax
      url: path
      type: 'GET'   
      data:
        subsidiary_id: $(this).attr('data-id')
      createSelectMenu(i, x)

  $(document).on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    $(this).prev().find('.remove_fields').show()
    number = $('.question-area').length    
    $(this).find('.position').val(number)
    createSelectMenu(i, x)
    event.preventDefault()

  $(document).ajaxComplete ->
    createSelectMenu(i, x)

