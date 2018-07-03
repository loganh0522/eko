module CandidateHelper
  def candidate_manual(activity)
    if activity.trackable.commentable.candidate.manually_created?
      return activity.trackable.commentable.candidate.user.full_name
    else 
      activity.trackable.commentable.candidate.full_name
    end
  end

  
  def candidate_user_avatar(candidate)
    if candidate.manually_created == true 
      content_tag(:div, image_tag("/tmp/little-man.png"), :class => 'circle-img' )  
    else
      if candidate.user.user_avatar.present? 
        content_tag(:div, image_tag(candidate.user.user_avatar.image.small_image), :class => 'circle', :size => "50x50") 
      else
        content_tag(:div, image_tag("/tmp/little-man.png"), :class => 'circle-img' ) 
      end 
    end
  end

  def task_link(task)
    if task.taskable.class == Candidate
      if task.job_id.present?
        app = Application.where(candidate_id: task.taskable_id, job_id: task.job_id).first
        link_to task.taskable.full_name, business_job_application_path(task.job_id, app)
      else
        link_to task.taskable.full_name, business_candidate_path(task.taskable)
      end
    elsif task.taskable.class == Job
      link_to "#{task.taskable.title}", business_job_path(task.taskable)
    end
  end

  def interview_link(interview)
    if interview.job_id.present? && interview.candidate_id.present?
      app = Application.where(candidate_id: interview.candidate_id, job_id: interview.job_id).first
      
      if app.present?
        link_to interview.candidate.full_name, business_job_application_path(interview.job_id, app)
      else
        link_to interview.candidate.full_name, business_candidate_path(interview.candidate)
      end

    else
      link_to interview.candidate.full_name, business_candidate_path(interview.candidate)
    end
  end

  def taskable_link(task)
    if task.taskable.class == Application
      if task.taskable.candidate.manually_created?
        @name = task.taskable.candidate.full_name
      else
        @name = task.taskable.candidate.user.full_name
      end
    end

    link_to(@name, '', data: {remote: true})
  end

  def card_overall_rating(overall)
    if overall == 1 
      content_tag(:div, "Definitely do not Recommend", :class => 'fa fa-times-circle')
    elsif overall == 2 
      content_tag(:div, "Do not Recommend", :class => 'fa fa-reject')
    elsif overall == 3
      content_tag(:div, "Recommend", :class => 'fa fa-thumbs-up')
    elsif overall == 4
      content_tag(:div, "Definitely Recommend", :class => 'fa fa-star')
    end
  end

  def user_avatar(user)
    if user.user_avatar.present?
      content_tag(:div, image_tag(user.user_avatar.image.small_image), :class => 'circle', :size => "50x50" )
    else 
      content_tag(:div, image_tag("/tmp/little-man.png"), :class => 'circle-img' ) 
    end
  end
end