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


  $(document).on 'click', '.interview-type', (event) ->
    if $(this).attr('id') == 'in-person'
      $('#interview-location').show()
    else 
      $('#interview-location').hide()
  
####### Add Certifications For Create Profile ########

  $('#add-certification').on 'click', '.add_fields', (event) -> 
    $('.not-present-container').hide()

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

################ Star Rating ##################
  $('#main-container').on 'click', '.star', (event) ->  
    PostCode = $(this).parent().parent().attr('id')
    Rating = $(this).val()
    $.ajax
      url : "/business/candidates/" + PostCode + "/ratings"
      type : "post"
      data:
        candidate_id: PostCode
        rating: Rating
  
  $(document).on 'click', '.responsive-menu', (event) ->
    if $('.responsive-menu-links').is(':visible')
      $('.responsive-menu-links').hide()
    else  
      $('.responsive-menu-links').show() 

################ Responsive Menu ############### 
  $(document).on 'click', '.toggle', (event) ->
    if $(this).hasClass('fa-angle-down')
      $(this).parent().next().show()
      $(this).parent().append("<i class='fa fa-angle-up toggle'></i>")
      $(this).remove()
    else if $(this).hasClass('fa-angle-up')
      $(this).parent().next().hide()
      $(this).parent().append("<i class='fa fa-angle-down toggle'></i>")
      $(this).remove()
      
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
  $(document).on 'keyup', '.number-only', (event) ->  
    if $.isNumeric($(this).val()) == false
      @value = @value.slice(0, -1)
    return

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



# Remove MainForm Container
  $(document).on 'click', '.remove-main-form', (e) -> 
    $('.main-form-container').remove()
    $('.main-container').show()

  $('.form-radios').on 'click', '.interview-kit-filter', (event) ->
    if $(this).attr('id') == 'questions'
      $('.questions-container').show()
      $('.overview-container').hide()
      $('.scorecard-container').hide()
      $('.interview-kit-filter').removeClass 'active'
      $(this).addClass 'active'
    else if $(this).attr('id') == 'scorecard'
      $('.questions-container').hide()
      $('.overview-container').hide()
      $('.scorecard-container').show()
      $('.interview-kit-filter').removeClass 'active'
      $(this).addClass 'active'
    else
      $('.scorecard-container').hide()
      $('.questions-container').hide()
      $('.overview-container').show()
      $('.interview-kit-filter').removeClass 'active'
      $(this).addClass 'active'
    return
