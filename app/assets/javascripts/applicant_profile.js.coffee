jQuery -> 

########### Change E-mail, Notes, Interview Actions ############

  changeAction = ($targetContainer) -> 
    $('.applicant-main-top').find('#showing-action').hide()
    $('.applicant-main-top').find('#showing-action').removeAttr('id', 'showing-action')    
    $($targetContainer).show()
    $($targetContainer).attr('id', 'showing-action') 
    return

  $('.application-actions').on 'click', '.btn-application-actions', (event) -> 
    if $(this).attr('id') == 'add-note'
      $targetContainer = '.comment-area'
    else if $(this).attr('id') == 'send-email'
      $targetContainer = '.email-area'
    $('.application-actions').find('.active-button').addClass('inactive-button').removeClass('active-button')
    $(this).addClass('active-button').removeClass('inactive-button')
    changeAction($targetContainer)
    return

######### NavBar Change Containers #############

  changeContainer = ($targetContainer) -> 
    $('#main-container').find('.showing').hide()
    $('#main-container').find('.showing').removeClass 'showing'
    $($targetContainer).show()
    $($targetContainer).addClass 'showing'
    return


  $('.change-containers-nav').on 'click', '.change', (event) -> 
    $targetContainer = '.' + $(this).attr('id') + '-container' 
    $('.change-containers-nav').find('.activated').removeClass 'activated'
    $(this).addClass 'activated'
    changeContainer $targetContainer
    return

############ Move Applicant Stages ###############

  $('#move-applicant-stages').change -> 
    $.ajax
      url : "/business/applications/change_stage"
      type : "post"
      data:
        stage: $('#move-applicant-stages :selected').data('id')
        application: $('#move-applicant-stages :selected').data('application')

  
  
#################### Close Tag Form ######################
  $('.add_tag').on 'click', '.close-form', (event) ->
    $('#add_tag').show()
    $('.tag_form').remove()

###################### Insert Fluid Variable into E-mail #####################

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

#################### Select All & Show Button's on Select ###################

  $('.applicants').on 'click', '.applicant-checkbox', (event) ->
    if $('.applicants').find('.applicant-checkbox :checked').size() > 0 
      $('.no-action-buttons').hide()
      $('.applicant-action-buttons').show()
    else if $('.applicants').find('.applicant-checkbox :checked').size() == 0
      $('.applicant-action-buttons').hide()
      $('.no-action-buttons').show()
    return

  $('.applicants').on 'click', '#Select_All', (event) ->
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

  $('.side-container').on 'click', '.glyphicon', (event) ->
    if $(this).hasClass('glyphicon-minus')
      $(this).parent().next().hide()
      $(this).hide()
      $(this).next().show()
    else if $(this).hasClass('glyphicon-plus')
      $(this).parent().next().show()
      $(this).hide()
      $(this).prev().show()
    return

########## Date Picker ##############

  $('#interview_interview_date').datepicker
    dateFormat: 'yy-mm-dd'
  $('.time_picker').timepicker()

#################### Add Applicants To Modal On Action Click #############################

  $('.applicants').on 'click', '#move-applicants', (event) ->
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

  $('.modal').on 'click', '.remove-recipient', (event) -> 
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
    return
  
  $("#geocomplete2").geocomplete()


  $('#interview-modal').on 'shown.bs.modal', ->
    $("#geocomplete2").geocomplete()

    $('#find').click ->
      $('input').trigger 'geocode'
      return

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
    console.log($(this).val())
    console.log($(this).parent().parent().attr('id'))
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

  $('.colorpicker').colorpicker({
    autoOpen: true
    hideOn:'button'})

  $('#cp2').colorpicker()
  return




