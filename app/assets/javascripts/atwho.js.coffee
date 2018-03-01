jQuery ->
  $('.comment-body').atwho
    at: '@'
    displayTpl: '<li> ${full_name} </li>',
    insertTpl: "<span contentEditable='false'; overflow='hidden'; class='user-tag'> ${full_name} </span>",
    'data': '/business/users'

  $('#add-note').on 'click', (e) ->
    console.log('comment click')

    $(document).on 'keypress', '.comment-body', (e) ->
      if e.keyCode == 64
        $(document).find(".comment-body").autocomplete(
          
          source: (request, response) ->  
            termIndex = request.term.indexOf('@') + 1
            $.ajax
              url: '/business/users'
              dataType: 'json'
              data:
                term: request.term[termIndex..]
              success: (data) ->
                response data
                return
            return

          appendTo: $('#comment-team-members')
          focus: (event, ui) ->
            $('#team-member-results').val ui.item.name
            false  
          select: (event, ui) -> 
            termIndex = $('.comment-body').html().indexOf('@')

            term = $('.comment-body').html().slice(/(\@)(.*?)(?=\s)/)
            $('.comment-body').html().replace(term, ' ')
            $('.comment-body').append("<span contentEditable= 'false'; overflow='hidden'; class='user-tag'; style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'>" + ui.item.full_name + "</span>")        
            false
        ).data('ui-autocomplete')._renderItem = (ul, item) ->
          $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
        return
      return
    return
      
  
  $('#add-note').on 'click', (e) ->
    
    document.addEventListener 'trix-initialize', (event) ->
      element = document.querySelector("trix-editor")
      editor = element.editor
      
      event.target.addEventListener 'keypress', (e) ->
        if e.keyCode == 64
          console.log(editor.getPosition())
          console.log(editor.getDocument().toString())
          console.log(editor.getClientRectAtPosition())
        return

    document.addEventListener 'trix-change', (e) ->
      console.log(e.keycode)


  $('#add-note').on 'click', (e) ->
    console.log('comment click')

    $(document).on 'keypress', '.comment-body', (e) ->
      if e.keyCode == 64
        $(document).find(".comment-body").autocomplete(
          
          source: (request, response) ->  
            termIndex = request.term.indexOf('@') + 1
            console.log(termIndex)
            $.ajax
              url: '/business/users'
              dataType: 'json'
              data:
                term: request.term[termIndex..]
              success: (data) ->
                response data
                return
            return

          appendTo: $('#comment-team-members')
          focus: (event, ui) ->
            $('#team-member-results').val ui.item.name
            false  
          select: (event, ui) -> 
            termIndex = $('.comment-body').html().indexOf('@')

            term = $('.comment-body').html().slice(/(\@)(.*?)(?=\s)/)
            $('.comment-body').html().replace(term, ' ')
            $('.comment-body').append("<span contentEditable= 'false'; overflow='hidden'; class='user-tag'; style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'>" + ui.item.full_name + "</span>")        
            false

        ).data('ui-autocomplete')._renderItem = (ul, item) ->
          $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul
        return
      return
    return
    