(function() {
  jQuery(function() {
    var config;
    config = {
      at: '@',
      data: '/business/users',
      displayTpl: '<li> ${full_name} <small> ${email} </small></li>',
      insertTpl: "<span contentEditable='true';> @${full_name} </span>",
      limit: 200
    };
    $('#froala-editor').on('froalaEditor.initialized', function(e, editor) {
      editor.$el.atwho(config);
      editor.events.on('keydown', (function(e) {
        if (e.which === $.FroalaEditor.KEYCODE.ENTER && editor.$el.atwho('isSelecting')) {
          return false;
        }
      }), true);
    }).froalaEditor();
  });

}).call(this);
