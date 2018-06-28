(function() {
  jQuery(function() {
    var buttonAction, buttonHTML, buttonSelector, pickFiles;
    buttonAction = "x-attach";
    buttonSelector = "button[data-trix-action='" + buttonAction + "']";
    buttonHTML = "<button type=\"button\" class=\"attach\" data-trix-action=\"" + buttonAction + "\">Attach Files</button>";
    $(Trix.config.toolbar.content).find(".button_group.block_tools").append(buttonHTML);
    $(document).on("trix-initialize", function($event) {
      var editorElement, toolbarElement;
      editorElement = $event.target;
      toolbarElement = editorElement.toolbarElement;
      return $(toolbarElement).find(buttonSelector).on("click", function() {
        editorElement.focus();
        pickFiles(function(files) {
          var file, i, len, results;
          results = [];
          for (i = 0, len = files.length; i < len; i++) {
            file = files[i];
            results.push(editorElement.editor.insertFile(file));
          }
          return results;
        });
        return false;
      });
    });
    return pickFiles = function(callback) {
      var $fileInput, uninstall;
      $fileInput = $("<input type=\"file\" multiple>");
      $fileInput.hide().appendTo("body");
      uninstall = function() {
        if ($fileInput) {
          $fileInput.remove();
          return $fileInput = null;
        }
      };
      $fileInput.on("change", function(event) {
        callback(this.files);
        return uninstall();
      });
      $fileInput.click();
      return requestAnimationFrame(function() {
        return $(document).one("click", uninstall);
      });
    };
  });

}).call(this);
