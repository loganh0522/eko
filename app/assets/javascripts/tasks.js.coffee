jQuery ->
  $('#task-layout').on 'click', 'label', -> 
    $.ajax
      url: '/business/tasks'
      type: 'GET'
      data:
        view: $(this).attr('id')

  $('#job-task-layout').on 'click', 'label', -> 
    $.ajax
      url: '/business/jobs/'+ id +'/tasks'
      type: 'GET'
      data:
        view: $(this).attr('id')

  $(document).on 'click', '.glyphicon-ok, .fa-check', -> 
    taskId = $(this).parent().parent().attr('id').slice(5)
    $.ajax
      url: '/business/tasks/completed'
      type: 'POST'
      data:
        id: taskId

