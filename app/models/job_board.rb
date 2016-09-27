class JobBoard < ActiveRecord::Base
  belongs_to :company 
  before_save :generate_subdomain!

  mount_uploader :logo, CareerPortalUploader

  def generate_subdomain!
    the_subdomain = to_subdomain(self.subdomain)  
    
    obj = JobBoard.find_by(subdomain: the_subdomain)
    count = 2 
    while obj && obj != self
      the_subdomain = append_suffix(the_subdomain, count) 
      obj = JobBoard.find_by(subdomain: the_subdomain)
      count += 1 
    end
    self.subdomain = the_subdomain.downcase
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0 
      return str.split('-').slice(0...-1).join('-') + '-' + count.to_s
    else
      return str + "-" + count.to_s
    end
  end

  def to_subdomain(name)
    str = self.subdomain
    str.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-' #replaces all non-alphanumeric symbols with a dash
    str.gsub! /-+/,'-' #replaces multiple dashes with one dash
    str.downcase
  end

end