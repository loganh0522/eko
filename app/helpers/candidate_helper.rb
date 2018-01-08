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
        content_tag(:div, image_tag(candidate.user.user_avatar.image.small_image), :class => 'circle') 
      else
        content_tag(:div, image_tag("/tmp/little-man.png"), :class => 'circle-img' ) 
      end 
    end
  end

  def user_avatar(user)
    if user.user_avatar.present?
      content_tag(:div, image_tag(user.user_avatar.image.small_image), :class => 'circle-img')
    else 
      content_tag(:div, image_tag("/tmp/little-man.png"), :class => 'circle-img' ) 
    end
  end
end