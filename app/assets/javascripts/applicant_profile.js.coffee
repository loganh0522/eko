jQuery -> 

##### Multiple modals ######
  $(".modal").on "shown.bs.modal", ->  
    if $('.modal-backdrop').length == 2
      $(this).css({'z-index':'1070'})
      $('.modal-backdrop').last().css({'z-index':'1060'})


########### Filter Jobs by Status ############
  $('.change-containers-nav').on 'click', '.job-status', (event) ->
    $('.change-containers-nav').find('.activated').removeClass('activated')
    $(this).addClass('activated')
    $.ajax
      url : "/business/jobs"
      type : "get"
      data:
        status: $(this).attr('id')
        
########### jquery selectmenu #######
  $('#selectmenu').selectmenu -> 
    style: 'popup'


#########  #############
  $('#task_due_date').datepicker
      dateFormat: 'yy-mm-dd'
  $('#timepicker').timepicker()


######### Scorecard JS #########
  $(document).ajaxComplete ->
    $('#task_due_date').datepicker  
      dateFormat: 'yy-mm-dd'

    $('#timepicker2').timepicker()
    $('#timepicker').timepicker()
    $("#geocomplete2").geocomplete()

    $('form').on 'focus', '#users-search', ->
      $('form').find('#users-search').autocomplete(
        source: '/business/users'
        appendTo: $('#user-results')
        focus: (event, ui) ->
          $('#users-search').val ui.item.name
          false
        select: (event, ui) ->
          $('.assigned-users').append('<div class="user-tag"> <div class="name">' + ui.item.full_name  + '</div> <div class="delete-tag"> &times </div> </div>') 

          values =  $('#user_ids').val() + ',' + ui.item.id 
          $('#user_ids').val values
          false
      ).data('ui-autocomplete')._renderItem = (ul, item) ->
        $('<li>').attr('ui-item-autocomplete', item.value).append("<a>" + item.full_name + "</a>").appendTo ul 
      return

############ Move Applicant Stages ###############

  $('#main-container').on 'change', '#move-applicant-stages', (event) ->
    $.ajax
      url : "/business/applications/change_stage"
      type : "post"
      data:
        stage: $('#move-applicant-stages :selected').data('id')
        application: $('#move-applicant-stages :selected').data('application')

  
#################### Close Tag Form ######################
  $('#main-container').on 'click', '.close-form', (event) ->
    console.log($(this).parent())
    $('#add_tag').show()
    $('.tag_form').remove()


###################### Insert Fluid Variable into E-mail #####################
  $(document).ajaxComplete ->
    $('#insert-fluid-variable').change -> 
      if $('#insert-fluid-variable').val() == "Applicant First Name"
        tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.first_name}}  </span>")
      else if $('#insert-fluid-variable').val() == "Applicant Last Name"
        tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.last_name}}  </span>")
      else if $('#insert-fluid-variable').val() == "Applicant Full Name"
        tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.full_name}}  </span>")
      else if $('#insert-fluid-variable').val() == "Job Title"
        tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{job.title}}  </span>")
      else if $('#insert-fluid-variable').val() == "Company Name"
        tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{company.name}}  </span>")
  
  $('#insert-fluid-variable').change -> 
    if $('#insert-fluid-variable').val() == "Applicant First Name"
      console.log('clicked')
      $('#message-body').append("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.first_name}}  </span>")
    else if $('#insert-fluid-variable').val() == "Applicant Last Name"
      tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.last_name}}  </span>")
    else if $('#insert-fluid-variable').val() == "Applicant Full Name"
      tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.full_name}}  </span>")
    else if $('#insert-fluid-variable').val() == "Job Title"
      tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{job.title}}  </span>")
    else if $('#insert-fluid-variable').val() == "Company Name"
      tinymce.activeEditor.execCommand('mceInsertContent', false, "<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{company.name}}  </span>")



#################### Select All & Show Button's on Select ###################

  $('#main-container').on 'click', '.applicant-checkbox', (event) ->
    if $('.applicants').find('.applicant-checkbox :checked').size() > 0 
      $('.no-action-buttons').hide()
      $('.applicant-action-buttons').show()
    else if $('.applicants').find('.applicant-checkbox :checked').size() == 0
      $('.applicant-action-buttons').hide()
      $('.no-action-buttons').show()
    return

  $('#main-container').on 'click', '#Select_All', (event) ->
    if $('.applicants').find('#select_all :checked').size() > 0
      $('.applicants').find('.applicant-checkbox').find('#applicant_ids_').prop("checked", true)
      $('.no-action-buttons').hide()
      $('.applicant-action-buttons').show()
    else if $('.applicants').find('#select_all :checked').size() == 0
      $('.applicants').find('.applicant-checkbox').find('#applicant_ids_').prop("checked", false)
      $('.applicant-action-buttons').hide()
      $('.no-action-buttons').show()
    return

################### Collapse SideBar #########################

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

#################### Add Applicants To Modal On Action Click #############################

  $('#main-container').on 'click', '#move-applicants', (event) ->
    checkbox = $('.applicant-checkbox')
    applicant_ids = []
    applicants = []
    applicant_names = []
    
    for n in checkbox   
      if $(n).find('input').is(':checked') == true     
        applicant = []
        applicant_ids.push($(n).data('id')) unless applicant_ids.includes($(n).data('id'))
        applicant.push($(n).data('id')) unless applicant.includes($(n).data('id'))
        
        applicant.push($(n).parent().parent().find('.name').data('id')) unless applicant.includes($(n).parent().parent().find('.name').data('id'))
        applicants.push(applicant)

    $('.modal').find('form').find('#applicant_ids').val(applicant_ids)
    
    for n in applicants
      $('.modal').find('.recipients').append('<div id="applicant" data-id=' + n[0] + '> <div class="name">' + n[1] + '</div> <div class="remove-recipient"> &times </div> </div>') 

  $('#main-container').on 'click', '.remove-recipient', (event) -> 
    $('.modal').find('form').find('#applicant_ids').val("")
    
    $(this).parent().remove()
    new_recipients = $('.recipients').children()
    applicant_ids = []
    
    for n in new_recipients
      applicant_ids.push($(n).data('id'))
    
    $('.modal').find('form').find('#applicant_ids').val(applicant_ids)

  $('.modal').on 'hidden.bs.modal', ->
    $('.recipients').children().remove() 

    return


################  Google Places JavaScript API ####################

  $("#geocomplete").geocomplete({
    types: ['(cities)']
  })

  $(document).ajaxComplete ->
    $('.work-experience').find('#geocomplete').geocomplete({
      types: ['(cities)']
    })
    $('#geocomplete').geocomplete({
      types: ['(cities)']
    })
    $("#geocomplete2").geocomplete()
    return
    


  $('#basic-form-modal').on 'shown.bs.modal', ->
    $('.event-form').find("#geocomplete2").geocomplete()
  

  $('#find').click ->
    $('input').trigger 'geocode'
    return


################## Sort Stages ####################

  $('#stages').sortable
    axis: 'y'
    cursor: 'move'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
  $("#stages").disableSelection()

################# Close Form ######################
  
  $(document).on 'click', '.close-form', (event) ->   
    if $(this).attr('id') == 'edit-form'
      console.log($(this).parent().attr('id'))
      formobj = $(this).parent().attr('id').slice(5)
      $("#" + "#{formobj}").show()
      $(this).parent().parent().remove()
    else if $(this).attr('id') == 'new-form'
      buttonobj = $(this).parent().attr('id')
      $("#" + "#{buttonobj}" + "_button").show()
      $(this).parent().parent().remove()
    return

  $('.modal-dialog').on 'click', '.close-form', (event) ->   
    if $(this).attr('id') == 'edit-form'
      formobj = $(this).parent().attr('id').slice(5)
      $("#" + "#{formobj}").show()
      $(this).parent().parent().remove()
    else if $(this).attr('id') == 'new-form'
      buttonobj = $(this).parent().attr('id')
      $("#" + "#{buttonobj}" + "_button").show()
      $(this).parent().parent().remove()
    return

################ Star Rating ##################
  $(document).on 'click', '.star', (event) ->  
    PostCode = $(this).parent().parent().attr('id')
    Rating = $(this).val()
    $.ajax
      url : "/business/applications/"+PostCode+"/ratings"
      type : "post"
      data:
        application_id: PostCode
        rating: Rating
    

################ Responsive Menu ############### 
  $(document).on 'click', '.responsive-menu', (event) ->
    if $('.responsive-menu-links').is(':visible')
      $('.responsive-menu-links').hide()
    else  
      $('.responsive-menu-links').show()

  $(window).on "resize", (event) -> 
    if $(this).width() > 780 
      $('.responsive-menu-links').hide()

############### Current Position ##################
  $(document).on 'click', '#work_experience_current_position', (event) ->
    if $(this).is(':checked') == true  
      $('#work_experience_end_month').hide()
      $('#work_experience_end_year').hide()
    else
      $('#work_experience_end_month').show()
      $('#work_experience_end_year').show()

  $(document).on 'click', '.edit-position', (event) ->
    if $('#work_experience_current_position').is(':checked') == true  
      $('#work_experience_end_month').hide()
      $('#work_experience_end_year').hide()
    else
      $('#work_experience_end_month').show()
      $('#work_experience_end_year').show()

############## Color Picker #################
  
  $('.colorpicker').colorpicker()



################# JQuery File Upload ######################

  $('#userProfilePictureModal').on 'click', (event) -> 
    $('#new_user_avatar').fileupload()


################ Job Board Layout Modal ###############
  
  $('#jobBoardRowModal').on 'click', '#layout-form', (event) ->
    $('.job-board-form').hide()
    $('.job-board-layout').show()

  $('#jobBoardRowModal').on 'click', '#content-form', (event) ->
    $('.job-board-form').show()
    $('.job-board-layout').hide()



