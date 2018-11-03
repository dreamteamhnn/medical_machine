$(document).on('turbolinks:load', function(){
  $('.button-delete-blog').on('click', function() {
    var modalOkBtn = $('#button-delete-blog-confirm');
    var blogId = $(this).data('blog-id');
    modalOkBtn.attr('data-blog-id', blogId);
    $('#delete-blog').modal('show');
    modalOkBtn.on('click', function() {
      $.ajax({
        url: '/admin/blogs/' + $(this).data('blog-id'),
        method: 'delete',
        success: function(result,status,xhr) {
        },
        error: function(xhr,status,error) {
        }
      });
    });
  });

  $('#blog_images').on('click', '.choose-img', function() {
    $(this).prev().trigger('click');
  });

  $('#blog_images').on('change', '.upload-blog-img', function() {
    var input = this;
    var url = $(this).val();
    var currentDom = $(this);
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
          currentDom.prev().find('img').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      currentDom.prev().find('img').attr('src', '/preview_no_image.jpg');
    }
  });

  // Load template data via ajax
  $('#blog_template_id').change(function() {
    var templateId = $(this).val();
    $.ajax({
      url: '/admin/templates/' + templateId,
      method: 'post',
      success: function(result, status, xhr) {
        if(result.status === 'success') {
          var templateConent = result.content;
          var ckContent = CKEDITOR.instances.blog_content.getData();
          var ckNewContent = templateConent.replace('[blog_content]', ckContent);
          CKEDITOR.instances.blog_content.setData(ckNewContent);
        }
      },
      error: function() {
      }
    });
  })
});
