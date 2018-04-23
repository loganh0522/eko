class HasEmailTemplates
  constructor: (elem) -> 
    @element = $(elem)
    @setCallbacks()

  setCallbacks: -> 
    @element.find("[data-behaviour= 'saved-template-select']").on "change", @handleChange

  handleChange: (e) =>
    textEditor = document.querySelector("trix-editor")
    saved_template_text = @element.find("[data-behaviour= 'saved-template-select']").find(":selected").data("body")
    comment_body = @element.find("[data-behaviour= 'comment-body']")
    
    textEditor.insertHtml("#{saved_template_text}")
    tinymce.activeEditor.execCommand('mceInsertContent', false, "#{saved_template_text}")

jQuery ->
  $.map $("[data-behaviour= 'has-saved-templates']"), (elem) ->
    new HasEmailTemplates(elem)

  $(document).on 'click', '.insert-template', (e) ->
    element = document.querySelector("trix-editor")
    txtBody = $(this).data('body')
    element.editor.insertHTML(txtBody)
    $('.hidden-search-box').hide()

  insertTemplate = -> 
    element = document.querySelector("trix-editor")
    txtBody = $(this).data('description')
    element.editor.loadHTML("")
    element.editor.insertHTML(txtBody)
    $('#job_title').val($(this).data('title'))
    $('.hidden-search-box').hide()

  $(document).on 'click', '.insert-job-template', (insertTemplate) 


  