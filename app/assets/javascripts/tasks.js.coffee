jQuery ->
  $('#task-layout').on 'click', 'label', -> 
    $.ajax
      url: '/business/tasks'
      type: 'GET'
      data:
        view: $(this).attr('id')

  $('#job-task-layout').on 'click', 'label', -> 
    jobId = $(this).data('job')
    $.ajax
      url: '/business/jobs/' + jobId + '/tasks'
      type: 'GET'
      data:
        view: $(this).attr('id')

  

