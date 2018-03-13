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