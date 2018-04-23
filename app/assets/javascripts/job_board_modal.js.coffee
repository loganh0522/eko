jQuery ->
  $(document).one 'click', '.add-job-board-sections', (event) ->
    $(document).on 'click', "#submit-section", (event) ->
      $("#job-board-section").submit();


    $(document).on 'click', '#layout-form', (event) ->
      $('.job-board-form').hide()
      $('.job-board-layout').show()
      $('#jobBoardRowModal').find('.active').removeClass('.active')
      $(this).addClass('.active')

    $(document).on 'click', '#content-form', (event) ->
      $('.job-board-form').show()
      $('.job-board-layout').hide()
      $('#jobBoardRowModal').find('.active').removeClass('.active')
      $(this).addClass('.active')