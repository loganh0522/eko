jQuery ->
  $(document).on 'click', '#add-skill', (event) ->
    tagName = $(this).parent().find('.ui-autocomplete-input').val() 
    newAttr = new Date().getTime();
    attrLength = $(this).parent().find('#skills').attr('name').length
    attrName = $(this).parent().find('#skills').attr('name').substr(0, attrLength - 7);
    startName = attrName + "[user_skills_attributes][" + newAttr + "][name]";
    
    $('.ui-autocomplete-input').val('')
    $(this).next('#add-tags').append('<div class="fieldset"><div class="user-tag"> <div class="name">' + tagName  + '</div> <div class="remove_fields"> &times </div> </div><input type="hidden" name="' + startName + '" value="' + tagName + '" /></div>');
    event.stopImmediatePropagation()
    return

  $(document).on 'click', '#add-skills', (event) ->
    tagName = $(this).parent().find('.ui-autocomplete-input').val();
    
    if $('#user-skills-field').val() == ''
      $('#user-skills-field').val(tagName)
    else 
      values =  $('#user-skills-field').val() + ',' + tagName
      $('#user-skills-field').val values 
    
    $('.ui-autocomplete-input').val('')
    $(this).next('#add-tags').append('<div class="fieldset"><div class="user-tag"> <div class="name">' + tagName  + '</div> <div class="remove_fields"> &times </div>');
    
    event.stopImmediatePropagation()
    return

  $('.ui-autocomplete-input').on 'focus', ->  
    controller = $(this).attr('class').split(' ').pop()
    if window.location.href.split('/').includes('business')
      route = 'business'
    else if window.location.href.split('/').includes('job_seeker')
      route = 'job_seeker'

    $(this).autocomplete( 
      source: '/' + route + '/' + controller + '/autocomplete'
      appendTo: $('#search-results-' + controller)     
      focus: (event, ui) -> 
        $(this).val(ui.item.name)
        false
      select: (event, ui) ->
        $(this).val(ui.item.name)
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete' , item.name).append("<a>" + item.name + "</a>").appendTo ul 
    return
  return


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
  $(document).on 'click', '#add-tag-button', (event) ->
    tagName = $('.ui-autocomplete-input').val() 
    $('.ui-autocomplete-input').val('')
    if tagName == ''
      return 
    else
      if $('#add-tags-value').val() == ''
        $('#add-tags-value').val tagName
      else 
        values =  $('#add-tags-value').val() + ',' + tagName 
        $('#add-tags-value').val values 
    $('#add-tags').append('<div class="user-tag"> <div class="name">' + tagName  + '</div> <div class="delete-tag"> &times </div> </div>') 
    event.stopImmediatePropagation()

  $(document).on 'click', '#add-skill', (event) ->
    tagName = $(this).parent().find('.ui-autocomplete-input').val() 
    newAttr = new Date().getTime();
    attrLength = $(this).parent().find('#skills').attr('name').length
    attrName = $(this).parent().find('#skills').attr('name').substr(0, attrLength - 7);
    startName = attrName + "[user_skills_attributes][" + newAttr + "][name]";
    
    $('.ui-autocomplete-input').val('')
    $(this).next('#add-tags').append('<div class="fieldset"><div class="user-tag"> <div class="name">' + tagName  + '</div> <div class="remove_fields"> &times </div> </div><input type="hidden" name="' + startName + '" value="' + tagName + '" /></div>');
    event.stopImmediatePropagation()
  return

  $('.ui-autocomplete-input').on 'focus', ->  
    controller = $(this).attr('class').split(' ').pop()
    if window.location.href.split('/').includes('business')
      route = 'business'
    else if window.location.href.split('/').includes('job_seeker')
      route = 'job_seeker'

    $(this).autocomplete( 
      source: '/' + route + '/' + controller + '/autocomplete'
      appendTo: $('#search-results-' + controller)     
      focus: (event, ui) -> 
        $(this).val(ui.item.name)
        false
      select: (event, ui) ->
        $(this).val(ui.item.name)
        false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li>').attr('ui-item-autocomplete' , item.name).append("<a>" + item.name + "</a>").appendTo ul 
    return
  return

  

  

  




