jQuery -> 
  $('.applicant-filter-checkbox').on 'click', '.filter-checkbox', (event) -> 
    filters = $('.filter-checkbox')
    Job = $('.filter-body').attr('id')
    action = window.location.pathname.split '/' 
    path = action[action.length - 1]

    Query = []
    AverageRating = []
    Tags = []
    JobStatus = []
    DateApplied = []
    JobAppliedTo = []
    LocationAppliedTo = []

    for n in filters 
      if $(n).is(':checked') == true      
        if $(n).parent().attr('id') == 'rating-filter'
          AverageRating.push($(n).val()) unless Tags.includes($(n).val())
        if $(n).parent().data('filter') == 'Tags' 
          Tags.push($(n).parent().data('id')) unless Tags.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'JobStatus'
          JobStatus.push($(n).parent().data('id')) unless JobStatus.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'DateApplied'
          DateApplied.push($(n).parent().data('id')) unless DateApplied.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'JobAppliedTo'
          JobAppliedTo.push($(n).parent().data('id')) unless JobAppliedTo.includes($(n).parent().data('id'))
        if $(n).parent().data('filter') == 'LocationAppliedTo'
          LocationAppliedTo.push($(n).parent().data('id')) unless LocationAppliedTo.includes($(n).parent().data('id'))
    
    $.ajax
      url : "/business/" + path + "/filter_applicants"
      type : "post"
      data:
        query: Query
        average_rating: AverageRating
        tags: Tags
        job_status: JobStatus
        date_applied: DateApplied
        job_applied: JobAppliedTo
        location_applied: LocationAppliedTo
        job_id: Job