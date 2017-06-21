class Client < ActiveRecord::Base
  belongs_to :company
  has_many :client_contacts
  has_many :jobs
  has_many :comments, as: :commentable
  has_many :tasks, as: :taskable


  def all_tasks
    @tasks = []
    self.tasks.each do |task|
      @tasks.append(task) unless @tasks.include?(task)
    end
    
    self.jobs.each do |job|
      job.applications.each do |application|
        application.tasks.each do |task|
          @tasks.append(task) unless @tasks.include?(task)
        end

        job.tasks.each do |task|
          @tasks.append(task) unless @tasks.include?(task)
        end
      end
    end
    return @tasks
  end

end