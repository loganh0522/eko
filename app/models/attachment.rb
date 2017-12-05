class Attachment < ActiveRecord::Base
  belongs_to :project
  
  mount_uploader :file, AttachmentUploader

  before_create :get_meta_links, if: :is_link?
  
  def get_meta_links
    page = MetaInspector.new(self.link)
    self.file_image = page.meta_tags['property']['og:image'].first
    self.link = page.meta_tags['property']['og:video:secure_url'].first
    self.title = page.meta_tags['property']['og:title'].first
    self.description = page.meta_tags['property']['og:description'].first
  end

  def is_link?
    link.present?
  end

  def is_not_link?
    !link.present?
  end

  def video_parse_function
    regex = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/
    link = params[:job_board_row][:video_link]
    @video_id = link.match(regex)[7]
  end
end