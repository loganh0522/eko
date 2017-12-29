class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png pdf doc docx txt mp3 xls xlsx)
  end

  version :large_image, :if => :image?  do
    resize_to_fill(500, 500)
  end
  
  version :medium_image, :if => :image?, from_version: :large_image do
    resize_to_fill(300, 300)
  end

  version :small_image, :if => :image?, from_version: :medium_image do
    resize_to_fill(200, 200)
  end

  version :thumb, :if => :image? do 
    resize_to_fill(100, 100)
  end


  def convert_to_image(width, height)
    image = ::Magick::Image.read(current_path + "[0]")[0]
    image.resize_to_fit(width, height).write(current_path)
    
    canvas = ::Magick::Image.new(image.columns, image.rows) { self.background_color = "#FFF" }
    # Merge PDF thumbnail onto canvas
    canvas.composite!(image, ::Magick::CenterGravity, ::Magick::OverCompositeOp)
  end

  version :pdf_thumb, :if => :pdf? do
    process :convert_to_image => [100, 100]
    process :convert => :jpg

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  version :pdf_medium, :if => :pdf? do
    process :convert_to_image => [300, 300]
    process :convert => :jpg

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  # version :thumb, :if => :thumbable? do
  #   process :resize_to_fill => [100, 100], :if => :image?
  #   process :pdf_preview => [100, 100], :if => :pdf?
  #   process :get_geometry
  
  #   def geometry
  #     @geometry
  #   end
  
  #   # We need to change the extension for PDF thumbnails to '.jpg'
  #   # def full_filename(filename)
  #   #   filename = File.replace_extension(filename, '.jpg') if File.extname(filename)=='.pdf'
  #   #   "thumb_#{filename}"
  #   # end
  # end

  # def pdf_preview(width, height)
  #   # Most PDFs have a transparent background, which becomes black when converted to jpg.
  #   # To override this, we must create a white canvas and composite the PDF onto the convas.
  #   # Read in first page of PDF and resize ([0] -> read the first page only)
  #   image = ::Magick::Image.read("#{current_path}[0]").first
  #   image.resize_to_fit!(width, height)
  #   # Create a blank canvas
  #   canvas = ::Magick::Image.new(image.columns, image.rows) { self.background_color = "#FFF" }
  #   # Merge PDF thumbnail onto canvas
  #   canvas.composite!(image, ::Magick::CenterGravity, ::Magick::OverCompositeOp)
  #   # Save as .jpg. We need to change the file extension here so that the fog gem picks it up and
  #   # sets the correct mime type. Otherwise the mime type will be set to PDF, which confuses browsers.
  #   canvas.write("jpg:#{current_path}")
  #   # file.move_to File.replace_extension(current_path, '.jpg')
  #   # Free memory allocated by RMagick which isn't managed by Ruby
  #   image.destroy!
  #   canvas.destroy!
  # rescue ::Magick::ImageMagickError => e
  #   Rails.logger.error "Failed to create PDF thumbnail: #{e.message}"
  #   raise CarrierWave::ProcessingError, "is not a valid PDF file"
  # end

  protected 
  
  def thumbable?(file)
    image?(file) || pdf?(file)
  end

  def image?(file)
    file.content_type.start_with? 'image'
  end

  def pdf?(file)
    file.content_type.include? "/pdf"
  end

  def get_geometry
    if (@file)
      img = ::Magick::Image::read(@file.file).first
      @geometry = { :width => img.columns, :height => img.rows }
    end
  end

  # def image?(new_file)
  #   new_file.content_type.start_with? 'image'
  # end

  # def pdf?(new_file)
  #   new_file.content_type.include? "/pdf"
  # end
end