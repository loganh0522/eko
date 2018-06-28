(function() {
  jQuery(function() {
    $('#task-layout').on('click', 'label', function() {
      return $.ajax({
        url: '/business/tasks',
        type: 'GET',
        data: {
          view: $(this).attr('id')
        }
      });
    });
    return $('#job-task-layout').on('click', 'label', function() {
      var jobId;
      jobId = $(this).data('job');
      return $.ajax({
        url: '/business/jobs/' + jobId + '/tasks',
        type: 'GET',
        data: {
          view: $(this).attr('id')
        }
      });
    });
  });

}).call(this);
