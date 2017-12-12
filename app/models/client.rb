class Client < ActiveRecord::Base
  belongs_to :company
  has_many :client_contacts, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  has_many :comments, as: :commentable, :dependent => :destroy
  has_many :tasks, as: :taskable, :dependent => :destroy
  
  validates_presence_of :company_name
  
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

  def open_tasks
    self.tasks.where(status: 'active')
  end

end