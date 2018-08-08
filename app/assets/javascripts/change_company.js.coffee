jQuery ->
	$(document).on 'click', '.insert-template', (e) ->
    element = document.querySelector("trix-editor")
    txtBody = $(this).data('body')
    element.editor.insertHTML(txtBody)
    $('.hidden-search-box').hide()

  
 


