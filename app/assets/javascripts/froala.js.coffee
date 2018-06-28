jQuery -> 
	$('#froala-editor').froalaEditor
    toolbarButtons: [
      'bold'
      'italic'
      'underline'
      'strikeThrough'
      'fontFamily'
      'fontSize'
      '|'
      'inlineStyle'
      'paragraphFormat'
      'align'
      'undo'
      'redo'
      'html'
    ]
    placeholderText: 'Start typing something (@mention team members)...'


  $(document).ajaxComplete ->

  	$('#froala-editor').froalaEditor
      toolbarButtons: [
        'bold'
        'italic'
        'underline'
        'strikeThrough'
        'fontFamily'
        'fontSize'
        '|'
        'inlineStyle'
        'paragraphFormat'
        'align'
        'undo'
        'redo'
        'html'
      ]
      placeholderText: 'Start typing something (@mention team members)...'