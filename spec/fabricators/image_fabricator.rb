Fabricator(:image) do
  file {
    ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join("spec/support/uploads/file.jpg")),
      :type => 'image/jpg',
      :filename => File.basename(File.new(Rails.root.join("spec/support/uploads/file.jpg")))
    )
  }
end