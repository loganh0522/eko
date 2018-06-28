jQuery ->
  config = 
    at: '@'
    data: '/business/users.json'
    searchKey: 'full_name'
    query: 'full_name'
    displayTpl: '<li> ${full_name} <small> ${email} </small></li>'
    insertTpl: "<span contentEditable='true';> @${full_name} </span>"
    limit: 7
    callbacks: matcher: (flag, subtext, should_start_with_space) ->
      match = undefined
      regexp = undefined
      flag = flag.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&')
      if should_start_with_space
        flag = '(?:^|\\s)' + flag
      regexp = new RegExp(flag + '([A-Za-z0-9_\\s+-]*)$|' + flag + '([^\\x00-\\xff]*)$', 'gi')
      match = regexp.exec(subtext.replace(/\s/g, ' '))
      if match
        match[2] or match[1]
      else
        null

  $('#froala-editor').on('froalaEditor.initialized', (e, editor) ->
    editor.$el.atwho config

    editor.events.on 'keydown', ((e) ->
      if e.which == $.FroalaEditor.KEYCODE.ENTER and editor.$el.atwho('isSelecting')
        return false
      return
    ), true
    return
  )

  $(document).ajaxComplete ->
    config = 
      at: '@'
      data: '/business/users.json'
      searchKey: 'full_name'
      query: 'full_name'
      displayTpl: '<li> ${full_name} <small> ${email} </small></li>'
      insertTpl: "<span contentEditable='true';> @${full_name} </span>"
      limit: 7
      callbacks: matcher: (flag, subtext, should_start_with_space) ->
        match = undefined
        regexp = undefined
        flag = flag.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&')
        if should_start_with_space
          flag = '(?:^|\\s)' + flag
        regexp = new RegExp(flag + '([A-Za-z0-9_\\s+-]*)$|' + flag + '([^\\x00-\\xff]*)$', 'gi')
        match = regexp.exec(subtext.replace(/\s/g, ' '))
        if match
          match[2] or match[1]
        else
          null

    $('#froala-editor').on('froalaEditor.initialized', (e, editor) ->
      editor.$el.atwho config
      editor.events.on 'keydown', ((e) ->
        if e.which == $.FroalaEditor.KEYCODE.ENTER and editor.$el.atwho('isSelecting')
          return false
        return
      ), true
      return
    )
    
    return