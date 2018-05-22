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

  

