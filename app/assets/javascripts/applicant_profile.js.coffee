jQuery ->
  $('#embedURL').gdocsViewer({width :'400',height : '500'})
  
  $('a[data-popup]').on 'click', (e) ->
    window.open $(this).attr('href')
    e.preventDefault()
    return

  $('#main-container').on 'click', '.applicant-checkbox', (event) ->
    if $('.applicants').find('.applicant-checkbox :checked').size() > 0 
      $('.no-action-buttons').hide()
      $('.applicant-action-buttons').show()
    else if $('.applicants').find('.applicant-checkbox :checked').size() == 0
      $('.applicant-action-buttons').hide()
      $('.no-action-buttons').show()
    return
  
  $('#main-container').on 'click', '#Select_All', (event) ->
    if $('#select_all :checked').size() > 0
      $('.checkbox').prop("checked", true)
      $('.no-action-buttons').hide()
      $('.applicant-action-buttons').show()
    else if $('#select_all :checked').size() == 0
      $('.checkbox').prop("checked", false)
      $('.applicant-action-buttons').hide()
      $('.no-action-buttons').show()
    return
    
############ Move Applicant Stages ###############

  $('#main-container').on 'change', '#move-applicant-stages', (event) ->
    $.ajax
      url : "/business/applications/move_stages"
      type : "post"
      data:
        stage: $('#move-applicant-stages :selected').data('id')
        application_id: $('#move-applicant-stages :selected').data('application')

  
#################### Add Applicants To Modal On Action Click #############################

  $('#destroy_candidatesModal').on 'shown.bs.modal', ->
    checkbox = $('.applicant-checkbox')
    $(this).find('#applicant_ids').val('')
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
    $(this).find('#applicant_ids').val(applicant_ids)
    for n in applicants
      $(this).find('.recipients').append('<div id="tag" data-id=' + n[0] + '> <div class="tag-name">' + n[1] + '</div> <div class="remove-recipient"> &times </div> </div>') 


################  Google Places JavaScript API ####################

  $("#geocomplete").geocomplete({
    types: ['(cities)']
  })
  $("#geocomplete2").geocomplete()

  $(document).ajaxComplete ->
    $('.work-experience').find('#geocomplete').geocomplete({
      types: ['(cities)']
    })
    
    $('#geocomplete').geocomplete({
      types: ['(cities)']
    })
    
    $("#geocomplete2").geocomplete()
    return
    
    $("#geocomplete-address").geocomplete({
      types: ['(address)']
    })
 

################# CloseForm ######################
  
  $('#main-container').on 'click', '.close-form', (event) ->   
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
  $('#main-container').on 'click', '.star', (event) ->  
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

# Job Board Layout Modal 
  
  $('#jobBoardRowModal').on 'click', '#layout-form', (event) ->
    $('.job-board-form').hide()
    $('.job-board-layout').show()
    $('#jobBoardRowModal').find('.active').removeClass('.active')
    $(this).addClass('.active')

  $('#jobBoardRowModal').on 'click', '#content-form', (event) ->
    $('.job-board-form').show()
    $('.job-board-layout').hide()
    $('#jobBoardRowModal').find('.active').removeClass('.active')
    $(this).addClass('.active')

  $(document).on 'keyup', '.number-only', (event) ->  
    if $.isNumeric($(this).val()) == false
      @value = @value.slice(0, -1)
    return


  $(document).on 'click', '.insert-template', (e) ->
    element = document.querySelector("trix-editor")
    txtBody = $(this).data('body')
    element.editor.insertHTML(txtBody)
    $('.hidden-search-box').hide()

  $(document).on 'click', '.insert-token', (event) ->
    element = document.querySelector("trix-editor")
    if $(this).attr('id') == "first-name"
      element.editor.insertHTML("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.first_name}} </span>")
    else if $(this).attr('id') == "last-name" 
      element.editor.insertHTML("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.last_name}} </span>")
    else if $(this).attr('id') == "full-name" 
      element.editor.insertHTML("<span contentEditable= 'false' class='class_one' style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{recipient.full_name}} </span>")
    else if $(this).attr('id') == "job-title" 
      element.editor.insertHTML("<span contentEditable= 'false' class='class_one' style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{job.title}} </span>")
    else if $(this).attr('id') == "company-name" 
      element.editor.insertHTML("<span contentEditable= 'false' class='class_one'  style='background-color: #f0f0f0; color: black; width: 100px; border-radius: 5px; border: solid 1px #dadada; height: 16px; text-align: center;'> {{company.name}} </span>")
    $(this).parent().parent().hide()

  
  
