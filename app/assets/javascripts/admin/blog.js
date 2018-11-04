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

  // bulk delete

  $('#bulk-delete-blogs-confirm-btn').on('click', function() {
    if(checkSelectedBlogsExist()) {
      $('#bulk-delete-blogs-modal').modal('hide');
      $('#bulk_delete_form').submit();
    } else {
      $('#bulk-delete-blogs-modal').modal('hide');
      $('#no-selected-blogs-alert-modal').modal('show');
    }
  });

  function checkSelectedBlogsExist() {
    var selectedBlogCount = $('.will-delete-blog-cb:checked').length;
    return selectedBlogCount > 0;
  }
});
