module JavascriptHelper
 
  def fill_in_trix_editor(id, value)
    find(:xpath, "//*[@id='#{id}']", visible: false).set(value)
  end
end