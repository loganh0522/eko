jQuery ->
  $('#calendar').fullCalendar({
    header: 
      right: 'month, agendaWeek',
      center: 'title'
      left: 'today prev, next'
    views: 
      agendaWeek: 
        type: 'agenda',
        duration: { days: 7 },
        buttonText: 'Week'

    businessHours: 
      dow: [ 1, 2, 3, 4, 5 ],
      start: '8:00', 
      end: '18:00'
  });