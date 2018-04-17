class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_admin? 
      can :manage, [Job, Candidate, JobFeed, 
        Task, Message, Interview, InterviewInvitation, JobBoard, JobTemplate, 
        User, Invitation, EmailTemplate, Company, HiringTeam, Scorecard, Stage, 
        Question, JobFeed]
    elsif user.permission.present?
      # Job Permissions
      can :create, Job if user.permission.create_job
      can :manage, JobFeed if user.permission.advertise_job

      if user.permission.view_all_jobs
        can :view, Job
        can :read, Job
        can :update, Job
      else
        can :read, Job, users: {id: user.id}
        can :view, Job, users: {id: user.id}
        can :update, Job, users: {id: user.id} if user.permission.edit_job

        can :manage, HiringTeam, job: {users: {id: user.id}} if user.permission.edit_job
        can :manage, Stage, job: {users: {id: user.id}} if user.permission.edit_job
        can :manage, Question, job: {users: {id: user.id}} if user.permission.edit_job
        can :manage, Scorecard, job: {users: {id: user.id}} if user.permission.edit_job
      end

      #### Candidate
      can :create, Candidate if user.permission.create_candidates
      
      if user.permission.view_all_candidates
        can :read, Candidate if user.permission.view_all_candidates
      else
        can :read, Candidate, applications: {job: {users: {id: user.id}}}
        can :view, Candidate, applications: {job: {users: {id: user.id}}}
      end

      # can [:move_stages], Candidate if user.permission.move_candidates
      can :update, Candidate if user.permission.edit_candidates
      can :destroy, Candidate if user.permission.edit_candidates

      #### Tasks 
      
      can :create, Task if user.permission.create_tasks
      can :assign_tasks, Task if user.permission.assign_tasks
      
      if user.permission.view_all_tasks && user.permission.view_all_jobs
        can :read, Task
      elsif user.permission.view_all_tasks
        can :read, Task, job: {users: {id: user.id}}
        can :edit, Task, user_id: user.id
        can :read, Task, user_id: user.id
        can :update, Task, user_id: user.id
        can :destroy, Task, user_id: user.id
        can [:completed], Task, user_id: user.id
      else
        can :read, Task, user_id: user.id
        can [:completed], Task, user_id: user.id
        can :job_tasks, Task
      end

      #### Messages
      
      

      if user.permission.view_all_messages
        can :manage, Message
      else
        can :read, Message, users: {id: user.id}
        can :create, Message if user.permission.send_messages
        can :read, Message if user.permission.view_section_messages
      end

      #### Calendar

      can :create, Interview if user.permission.create_event
      can :create, InterviewInvitation if user.permission.send_event_invitation
      
      if user.permission.view_all_events && user.permission.view_all_jobs
        can :manage, Interview
        can :manage, InterviewInvitation
      elsif user.permission.view_all_events
        can :read, Interview, job: {users: {id: user.id}}
        can :read, InterviewInvitation, job: {users: {id: user.id}}

        can :edit, Interview, user_id: user.id
        can :read, Interview, user_id: user.id

        can :update, Interview, user_id: user.id
        can :destroy, Interview, user_id: user.id
      else
        can :read, Interview, users: {id: user.id}
        cannot :read, InterviewInvitation
      end

      ### General Settings
      # can :read, Analytic if user.permission.view_analytics
      can :manage, JobBoard if user.permission.edit_career_portal
      can :manage, User, user_id: user.id

      if user.permission.access_settings
        can :manage, User
        can :manage, Invitation
        can :manage, EmailTemplate
        can :manage, JobTemplate
        can :manage, Company
      end
    end

    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
