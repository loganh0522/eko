authorization do 
  role :admin do 
    has_permission_on [:business_job, :business_jobs, :business_candidates, 
      :business_comments, :business_activities, :business_application_emails,
      :business_application_scorecards, :business_applications,
      :business_client_contacts, :business_clients, :business_companies,
      :business_customers, :business_default_stages, :business_email_signatures,
      :business_email_templates, :business_hiring_teams, :business_interviews,
      :business_invitations, :business_job_board_headers, :business_job_board_rows,
      :business_job_boards, :business_messages, :business_notifications,
      :business_questionairres, :business_questions, :business_ratings,
      :business_rejection_reasons, :business_scorecard_sections, :business_scorecards,
      :business_stages, :business_tags, :business_tasks, :business_user_avatars,
      :business_users], :to => :manage

    has_permission_on [:business_jobs], :to => :manage do
      has_permission_on [:business_job], :to => :manage
    end
  end

  role :hiring_manager do
    has_permission_on [:business_activities], :to => :read  
    
    has_permission_on [:business_job], :to => :show do
      if_attribute :business_job => {:users => contains {user}}
    end

    has_permission_on [:business_jobs], :to => :index 

    has_permission_on [:business_comments, :business_tasks, 
      :business_application_scorecards, :business_messages,
      :business_applications], :to => [:read, :create]  
    has_permission_on [:business_comments, :business_application_scorecards, 
      :business_tasks], :to => [:update, :destroy] do
      if_attribute :user => is {user}
    end
    has_permission_on [:business_users, :business_email_signatures], :to => [:update, :read]
  end

  role :recruiter do 
    has_permission_on [:business_jobs], :to => :read do
      if_attribute :user => is {user}
    end

  end
end

privileges do 
  privilege :manage do 
    includes :create, :read, :update, :delete
  end
  privilege :create, :includes => :new
  privilege :read, :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end