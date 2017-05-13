jQuery -> 

########### Change E-mail, Notes, Interview Actions ############


######### NavBar Change Containers #############


############ Move Applicant Stages ###############

  $('#main-container').on 'change', '#move-applicant-stages', (event) ->
    console.log("action-takents") 
    $.ajax
      url : "/business/applications/change_stage"
      type : "post"
      data:
        stage: $('#move-applicant-stages :selected').data('id')
        application: $('#move-applicant-stages :selected').data('application')

  
  
#################### Close Tag Form ######################
  $('#main-container').on 'click', '.close-form', (event) ->
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
    console.log("complete")
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


############# Application Filters ################## 
  
  $('.applicant-filter-checkbox').on 'click', '.filter-checkbox', (event) -> 
    filters = $('.filter-checkbox')

    # console.log($(this).attr('value'))
    # console.log($(this).parent().attr('class'))
    # console.log($(this).parent().parent().attr('class'))

    Query = []
    AverageRating = []
    Tags = []
    JobStatus = []
    DateApplied = []
    JobAppliedTo = []
    LocationAppliedTo = []

    for n in filters 

      if $(n).is(':checked') == true      
        if $(n).parent().attr('id') == 'rating-filter'
          AverageRating.push($(n).val()) unless Tags.includes($(n).val())
        if $(n).parent().data('filter') == 'Tags' 
          Tags.push($(n).parent().data('id')) unless Tags.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'JobStatus'
          JobStatus.push($(n).parent().data('id')) unless JobStatus.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'DateApplied'
          DateApplied.push($(n).parent().data('id')) unless DateApplied.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'JobAppliedTo'
          JobAppliedTo.push($(n).parent().data('id')) unless JobAppliedTo.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'LocationAppliedTo'
          LocationAppliedTo.push($(n).parent().data('id')) unless LocationAppliedTo.includes($(n).parent().data('id'))

        

    $.ajax
      url : "/business/applications/filter_applicants"
      type : "post"
      data:
        query: Query
        average_rating: AverageRating
        tags: Tags
        job_status: JobStatus
        date_applied: DateApplied
        job_applied: JobAppliedTo
        location_applied: LocationAppliedTo


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



