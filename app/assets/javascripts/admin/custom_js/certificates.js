$(document).on('turbolinks:load', function(){
  $(".button-delete-certificate").click(function() {
    var certificateId = $(this)[0].id.replace("delete-certificate", "");
    $("#delete-certificate .delete-certificate-id").val(certificateId);
  });

  $("#button-delete-certificate-confirm").click(function() {
    var certificateId = $("#delete-certificate .delete-certificate-id").val();
    $.ajax({
      type: "DELETE",
      url: "certificates/" + certificateId
    }).done(function(response) {
    });
  });

  $("#upload-certificate-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#certificate-new .preview-certificate-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#certificate-new .preview-certificate-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $("#upload-certificate-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#certificate-new .preview-certificate-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#certificate-new .preview-certificate-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $('#dataTables-certificate').DataTable({
    responsive: true
  });
});
