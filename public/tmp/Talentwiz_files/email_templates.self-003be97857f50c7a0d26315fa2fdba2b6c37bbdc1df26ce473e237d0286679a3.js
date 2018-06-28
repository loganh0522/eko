(function() {
  var HasEmailTemplates,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  HasEmailTemplates = (function() {
    function HasEmailTemplates(elem) {
      this.handleChange = bind(this.handleChange, this);
      this.element = $(elem);
      this.setCallbacks();
    }

    HasEmailTemplates.prototype.setCallbacks = function() {
      return this.element.find("[data-behaviour= 'saved-template-select']").on("change", this.handleChange);
    };

    HasEmailTemplates.prototype.handleChange = function(e) {
      var comment_body, saved_template_text, textEditor;
      textEditor = document.querySelector("trix-editor");
      saved_template_text = this.element.find("[data-behaviour= 'saved-template-select']").find(":selected").data("body");
      comment_body = this.element.find("[data-behaviour= 'comment-body']");
      textEditor.insertHtml("" + saved_template_text);
      return tinymce.activeEditor.execCommand('mceInsertContent', false, "" + saved_template_text);
    };

    return HasEmailTemplates;

  })();

  jQuery(function() {
    var insertTemplate;
    $.map($("[data-behaviour= 'has-saved-templates']"), function(elem) {
      return new HasEmailTemplates(elem);
    });
    $(document).on('click', '.insert-template', function(e) {
      var element, txtBody;
      element = document.querySelector("trix-editor");
      txtBody = $(this).data('body');
      element.editor.insertHTML(txtBody);
      return $('.hidden-search-box').hide();
    });
    insertTemplate = function() {
      var element, txtBody;
      element = document.querySelector("trix-editor");
      txtBody = $(this).data('description');
      element.editor.loadHTML("");
      element.editor.insertHTML(txtBody);
      $('#job_title').val($(this).data('title'));
      return $('.hidden-search-box').hide();
    };
    return $(document).on('click', '.insert-job-template', insertTemplate);
  });

}).call(this);
