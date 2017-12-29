class Attachment < ActiveRecord::Base
  belongs_to :project
  
  mount_uploader :file, AttachmentUploader


  # before_create :get_meta_links, if: :is_link?
  # before_create :convert_pdf_to_image
  before_destroy :clean_s3
  
  def get_meta_links
    page = MetaInspector.new(self.link)
    self.file_image = page.meta_tags['property']['og:image'].first if page.meta_tags['property']['og:image'].present?
    self.video_url = page.meta_tags['property']['og:video:secure_url'].first if page.meta_tags['property']['og:video:secure_url'].present?
    self.link = page.meta_tags['property']['og:url'] if page.meta_tags['property']['og:url']
    self.title = page.meta_tags['property']['og:title'].first if page.meta_tags['property']['og:title'].present?
    self.description = page.meta_tags['property']['og:description'].first if page.meta_tags['property']['og:description'].present?
  end

  # def convert_pdf_to_image
  #   pdf = Magick::ImageList.new(self.file)
  #   pdf.write("myimage.jpeg")
  # end

  def clean_s3
    file.remove!
    file.thumb.remove! # if you have thumb version or any other version
    file.large_image.remove!
    file.medium_image.remove!
    file.small_image.remove!
    file.pdf_thumb.remove!
    file.pdf_medium.remove!
  rescue Excon::Errors::Error => error
    puts "Something gone wrong"
    false
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