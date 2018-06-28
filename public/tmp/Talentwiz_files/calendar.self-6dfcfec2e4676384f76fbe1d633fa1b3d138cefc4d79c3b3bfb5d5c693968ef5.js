(function() {
  jQuery(function() {
    return $('#calendar').fullCalendar({
      header: {
        right: 'list, month, agendaWeek',
        center: 'title',
        left: 'today prev, next'
      },
      views: {
        agendaWeek: {
          type: 'agenda',
          duration: {
            days: 7
          },
          buttonText: 'Week'
        }
      },
      businessHours: {
        dow: [1, 2, 3, 4, 5],
        start: '8:00',
        end: '18:00'
      },
      selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,
      events: '/business/interviews.json',
      select: function(start, end) {
        $.getScript('/business/interviews/new', function() {
          $('#event_date_range').val(moment(start).format('MM/DD/YYYY HH:mm') + ' - ' + moment(end).format('MM/DD/YYYY HH:mm'));
          date_range_picker();
          $('.start_hidden').val(moment(start).format('YYYY-MM-DD HH:mm'));
          $('.end_hidden').val(moment(end).format('YYYY-MM-DD HH:mm'));
        });
        calendar.fullCalendar('unselect');
      }
    });
  });

}).call(this);
