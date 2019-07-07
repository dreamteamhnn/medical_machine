$(document).on('turbolinks:load', function(){
  $("#upload-company-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#company-show .preview-company-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#company-show .preview-company-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $("#upload-company-watermark-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#company-show .preview-company-watermark-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#company-show .preview-company-watermark-image').attr('src', '/preview_no_image.jpg');
    }
  });
});
