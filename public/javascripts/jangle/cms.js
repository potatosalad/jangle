$.CMS = function(){
  var current_path = window.location.pathname;
  var admin_path_prefix = current_path.split('/')[1]
  
  $(function(){
    
    $.CMS.slugify();
    $.CMS.tree_methods();
    $.CMS.load_page_blocks();
    //$.CMS.enable_rich_text();
    $.CMS.enable_codemirror();
    $.CMS.enable_date_picker();
    $.CMS.enable_desc_toggle();
    $.CMS.enable_sortable_list();
    if($('form.new_jangle_page, form.edit_jangle_page').get(0)) $.CMS.enable_page_save_form();
    if($('form.new_jangle_widget, form.edit_jangle_widget').get(0)) $.CMS.enable_widget_save_form();
    if($('#page_save').get(0))        $.CMS.enable_page_save_widget();
    if($('#widget_save').get(0))      $.CMS.enable_widget_save_widget();
    if($('#uploader_button').get(0))  $.CMS.enable_uploader();
  });
  
  return {
    
    enable_sortable_list: function(){
      $('ul.sortable, ul.sortable ul').sortable({
        handle: 'div.dragger',
        axis: 'y',
        update: function(){
          $.post(current_path + '/reorder', '_method=put&'+$(this).sortable('serialize'));
        }
      })
    },
    
    slugify: function(){
      $('input.slugify').bind('keyup.cms', function() {
        var slug_input = $('input.slug');
        var delimiter = slug_input.hasClass('delimiter-underscore') ? '_' : '-';
        slug_input.val( slugify( $(this).val(), delimiter ) );
      });

      function slugify(str, delimiter){
        var opposite_delimiter = (delimiter == '-') ? '_' : '-';
        str = str.replace(/^\s+|\s+$/g, '');
        var from = "ÀÁÄÂÈÉËÊÌÍÏÎÒÓÖÔÙÚÜÛàáäâèéëêìíïîòóöôùúüûÑñÇç";
        var to   = "aaaaeeeeiiiioooouuuuaaaaeeeeiiiioooouuuunncc";
        for (var i=0, l=from.length ; i<l ; i++) {
          str = str.replace(new RegExp(from[i], "g"), to[i]);
        }
        var chars_to_replace_with_delimiter = new RegExp('[·/,:;'+ opposite_delimiter +']', 'g');
        str = str.replace(chars_to_replace_with_delimiter, delimiter);
        var chars_to_remove = new RegExp('[^a-zA-Z0-9 '+ delimiter +']', 'g');
        str = str.replace(chars_to_remove, '').replace(/\s+/g, delimiter).toLowerCase();
        return str;
      }
    },
    
    // Load Page Blocks on layout change
    load_page_blocks: function(){
      $('select#jangle_page_jangle_layout_id').bind('change.cms', function() {
        $.ajax({
          url: ['/' + admin_path_prefix, 'pages', $(this).attr('data-page-id'), 'form_blocks'].join('/'),
          data: ({
            layout_id: $(this).val()
          }),
          complete: function(){ 
            $.CMS.enable_rich_text();
            $.CMS.enable_date_picker();
          }
        })
      });
    },

    // Load Widget Blocks on template change
    load_widget_blocks: function(){
      $('select#jangle_widget_jangle_template_id').bind('change.cms', function() {
        $.ajax({
          url: ['/' + admin_path_prefix, 'widgets', $(this).attr('data-widget-id'), 'form_blocks'].join('/'),
          data: ({
            layout_id: $(this).val()
          }),
          complete: function(){ 
            $.CMS.enable_rich_text();
            $.CMS.enable_date_picker();
          }
        })
      });
    },
    
    enable_rich_text: function(){
      $('textarea.rich_text').tinymce({
         theme : "advanced",
         plugins: "",
         theme_advanced_buttons1 : "formatselect,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,link,unlink,anchor,image,|,code",
         theme_advanced_buttons2 : "",
         theme_advanced_buttons3 : "",
         theme_advanced_buttons4 : "",
         theme_advanced_toolbar_location : "top",
         theme_advanced_toolbar_align : "left",
         theme_advanced_statusbar_location : "bottom",
         theme_advanced_resizing : true,
         theme_advanced_resize_horizontal : false
       });
    },

    addCodeMirrorEditor: function(type, el, parser) {
      parser = (parser || 'Liquid') + 'Parser';
      var editor = CodeMirror.fromTextArea(el.attr('id'), {
        basefiles: '/javascripts/jangle/codemirror/codemirror_base.min.js',
        stylesheet: [
          "/stylesheets/jangle/codemirror/csscolors.css",
          "/stylesheets/jangle/codemirror/xmlcolors.css",
          "/stylesheets/jangle/codemirror/javascriptcolors.css",
          "/stylesheets/jangle/codemirror/liquidcolors.css"
        ],
        continuousScanning: 500,
        reindentOnLoad: true,
        initCallback: function(editor) {
          jQuery(editor.frame.contentDocument).keydown(function(event) {
            jQuery(document).trigger(event);
          });
          editor.setParser(parser);
        },
        lineNumbers: true
      });
    },

    enable_codemirror: function() {
      $('textarea.code.html').each(function(i, element) {
        CodeMirror.fromTextArea(element, {
          basefiles: '/javascripts/jangle/codemirror/codemirror_base.min.js',
          stylesheet: [
            "/stylesheets/jangle/codemirror/csscolors.css",
            "/stylesheets/jangle/codemirror/xmlcolors.css",
            "/stylesheets/jangle/codemirror/javascriptcolors.css",
            "/stylesheets/jangle/codemirror/liquidcolors.css"
          ],
          continuousScanning: 500,
          reindentOnLoad: true,
          initCallback: function(editor) {
            jQuery(editor.frame.contentDocument).keydown(function(event) {
              jQuery(document).trigger(event);
            });
            editor.setParser('LiquidParser');
          },
          lineNumbers: true
        });
      });
      
      $('textarea.code.css').each(function(i, element){
        $.CMS.addCodeMirrorEditor(null, $(element), 'CSS');
      });
      
      $('textarea.code.js').each(function(i, element){
        $.CMS.addCodeMirrorEditor(null, $(element), 'JS');
      });
    },
    
    enable_date_picker: function(){
      $('input[type=datetime]').datepicker();
    },
    
    enable_desc_toggle: function(){
      $('.form_element .desc .desc_toggle').click(function(){
        $(this).toggle();
        $(this).siblings('.desc_content').toggle();
      })
    },
    
    tree_methods: function(){
      $('a.tree_toggle').bind('click.cms', function() {
        $(this).siblings('ul').toggle();
        $(this).toggleClass('closed');
        // object_id are set in the helper (check cms_helper.rb)
        $.ajax({url: [current_path, object_id, 'toggle'].join('/')});
      });
      
      $('ul.sortable').each(function(){
        $(this).sortable({
          handle: 'div.dragger',
          axis: 'y',
          update: function() {
            $.post(current_path + '/reorder', '_method=put&'+$(this).sortable('serialize'));
          }
        })
      });
    },
    
    enable_page_save_widget : function(){
      $('#page_save input').attr('checked', $('input#jangle_page_is_published').is(':checked'));
      $('#page_save button').html($('input#jangle_page_submit').val());
      
      $('#page_save input').bind('click', function(){
        $('input#jangle_page_is_published').attr('checked', $(this).is(':checked'));
      })
      $('input#jangle_page_is_published').bind('click', function(){
        $('#page_save input').attr('checked', $(this).is(':checked'));
      })
      $('#page_save button').bind('click', function(){
        $('input#jangle_page_submit').click();
      })
    },

    enable_widget_save_widget : function(){
      $('#widget_save input').attr('checked', $('input#jangle_widget_is_published').is(':checked'));
      $('#widget_save button').html($('input#jangle_widget_submit').val());
      
      $('#widget_save input').bind('click', function(){
        $('input#jangle_widget_is_published').attr('checked', $(this).is(':checked'));
      })
      $('input#jangle_widget_is_published').bind('click', function(){
        $('#widget_save input').attr('checked', $(this).is(':checked'));
      })
      $('#widget_save button').bind('click', function(){
        $('input#jangle_widget_submit').click();
      })
    },
    
    enable_page_save_form : function(){
      $('input[name=commit]').click(function() {
        $(this).parents('form').attr('target', '');
      });
      $('input[name=preview]').click(function() {
        $(this).parents('form').attr('target', '_blank');
      });
    },

    enable_widget_save_form : function(){
      $('input[name=commit]').click(function() {
        $(this).parents('form').attr('target', '');
      });
      $('input[name=preview]').click(function() {
        $(this).parents('form').attr('target', '_blank');
      });
    },
    
    enable_uploader : function(){
      auth_token = $("meta[name=csrf-token]").attr('content');
      var uploader = new plupload.Uploader({
        container:        'file_uploads',
        browse_button:    'uploader_button',
        runtimes:         'html5',
        unique_names:     true,
        multipart:        true,
        multipart_params: { authenticity_token: auth_token, format: 'js' },
        url:              '/' + admin_path_prefix + '/uploads'
      });
      uploader.init();
      uploader.bind('FilesAdded', function(up, files) {
        $.each(files, function(i, file){
          $('#uploaded_files').prepend(
            '<div class="file pending" id="' + file.id + '">' + file.name + '</div>'
          );
        });
        uploader.start();
      });
      uploader.bind('Error', function(up, err) {
        alert('File Upload failed')
      });
      uploader.bind('FileUploaded', function(up, file, response){
        $('#' + file.id).replaceWith(response.response);
      });
    }
  }
}();