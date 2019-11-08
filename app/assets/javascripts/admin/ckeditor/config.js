CKEDITOR.editorConfig = function( config )
{
    config.toolbar = 'article';
    config.toolbar_article = [
        { name: 'document', items: [ 'NewPage' ] },
        { name: 'clipboard', items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
        { name: 'editing', items: [ 'Find', 'Replace', '-', 'SelectAll', '-', 'Scayt' ] },
        { name: 'insert', items: [ 'Image', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'Iframe' ] },
        { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
        '/',
        { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote' ] },
        { name: 'alignment', items: [ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
        { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
        { name: 'styles', items: [ 'Styles', 'Format' ] },
        { name: 'tools', items: [ 'Maximize', '-', 'Preview' ] }
    ];

    config.toolbar = 'comment';
    config.toolbar_comment = [
        { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
        { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote' ] },
        { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
        { name: 'tools', items: [ 'Maximize', '-', 'Preview' ] }
    ];
};