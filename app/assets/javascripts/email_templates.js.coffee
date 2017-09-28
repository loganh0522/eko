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
    
    textEditor.insertString
    tinymce.activeEditor.execCommand('mceInsertContent', false, "#{saved_template_text}")

jQuery ->
  $.map $("[data-behaviour= 'has-saved-templates']"), (elem) ->
    new HasEmailTemplates(elem)