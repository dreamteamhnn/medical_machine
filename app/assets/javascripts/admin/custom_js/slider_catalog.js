$(document).on('turbolinks:load', function(){
  $(".button-delete-slider").click(function() {
    var sliderId = $(this)[0].id.replace("delete-slider", "");
    $("#delete-slider .delete-slider-id").val(sliderId);
  });

  $("#button-delete-slider-confirm").click(function() {
    var sliderId = $("#delete-slider .delete-slider-id").val();
    $.ajax({
      type: "DELETE",
      url: "sliders/" + sliderId
    }).done(function(response) {
    });
  });

  $("#upload-slider-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#slider-new .preview-slider-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#slider-new .preview-slider-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $(".button-delete-catalog").click(function() {
    var catalogId = $(this)[0].id.replace("delete-catalog", "");
    $("#delete-catalog .delete-catalog-id").val(catalogId);
  });

  $("#button-delete-catalog-confirm").click(function() {
    var catalogId = $("#delete-catalog .delete-catalog-id").val();
    $.ajax({
      type: "DELETE",
      url: "catalogs/" + catalogId
    }).done(function(response) {
    });
  });

  $("#upload-catalog-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#catalog-new .preview-catalog-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#catalog-new .preview-catalog-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $('#dataTables-slider').DataTable({
    responsive: true
  });

  $('#dataTables-catalog').DataTable({
    responsive: true
  });
});
