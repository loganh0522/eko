jQuery ->
  $(document).on 'click', '#remove_form', (event) ->
    if $(this).closest('form').attr('class') == 'edit_comment'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").find('.activity-body-body').find('.comment-body').show()
      $(this).closest('form').remove()
    else if $(this).closest('form').attr('class') == 'edit_question'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").show()
      $(this).closest('form').remove()
    else if $(this).closest('form').attr('class') == 'edit_scorecard'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").show()
      $(this).closest('form').remove()
      $('.container-footer').show()

    else if $(this).closest('form').attr('class') == 'edit_task'
      $(this).parent().parent().parent().parent().find('.task-details').show()
      $(this).closest('form').remove()    
      
    else if $(this).closest('form').attr('class') == 'edit_application_scorecard'
      qid = $(this).closest('form').attr('id').slice(5)
      $(this).closest('form').remove()
      $('.display-applicant-details').html('<%= j render "business/application_scorecards/applicant_scorecard" %>');
    else if $(this).closest('form').attr('class') == 'edit_accomplishment'
      qid = $(this).closest('form').attr('id').slice(5)
      $("#" + "#{qid}").show()
      $(this).closest('form').remove()
    else
      $(this).closest('form').remove()
    return
    event.preventDefault()
