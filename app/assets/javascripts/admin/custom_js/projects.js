$(document).on('turbolinks:load', function(){
  $(".button-delete-project").click(function() {
    var projectId = $(this)[0].id.replace("delete-project", "");
    $("#delete-project .delete-project-id").val(projectId);
  });

  $("#button-delete-project-confirm").click(function() {
    var projectId = $("#delete-project .delete-project-id").val();
    $.ajax({
      type: "DELETE",
      url: "projects/" + projectId
    }).done(function(response) {
    });
  });

  $("#upload-project-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#project-new .preview-project-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#project-new .preview-project-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $("#upload-project-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#project-new .preview-project-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#project-new .preview-project-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $('#dataTables-project').DataTable({
    responsive: true
  });
});
