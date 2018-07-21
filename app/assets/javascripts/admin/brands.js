$(document).on('turbolinks:load', function(){
  $(".confirm-brand-save").click(function() {
    var brandId = $(this)[0].name.replace("update-brand", "");
    var brandName = $("#brand-name"+brandId).val();
    var brandOrder = $("#brand-order"+brandId).val();
    var brandDes = $("#brand-des"+brandId).val();
    var brandLocation = $("#brand-location"+brandId).val();
    $("#brand-name"+brandId).addClass("hidden");
    $("#brand-order"+brandId).addClass("hidden");
    $("#brand-des"+brandId).addClass("hidden");
    $("#brand-location"+brandId).addClass("hidden");
    $.ajax({
      data: {
        name: brandName,
        home_order: brandOrder,
        location: brandLocation,
        description: brandDes
      },
      type: "PATCH",
      url: "brands/" + brandId
    }).done(function(response) {
      $("#brand-table .alert-success-update").removeClass("hidden");
      $("#brand-table .alert-danger-update").addClass("hidden");
      $("#p-brand-name"+brandId).removeClass("hidden");
      $("#p-brand-order"+brandId).removeClass("hidden");
      $("#p-brand-des"+brandId).removeClass("hidden");
      $("#p-brand-location"+brandId).removeClass("hidden");
      $("#p-brand-name"+brandId)[0].innerHTML = response.name;
      $("#p-brand-order"+brandId)[0].innerHTML = response.home_order;
      $("#p-brand-des"+brandId)[0].innerHTML = response.description;
      $("#p-brand-location"+brandId)[0].innerHTML = response.location;
    }).fail(function(errors) {
      $("#brand-table .alert-danger-update").removeClass("hidden");
      $("#brand-table .alert-success-update").addClass("hidden");
    });
  });

  $(".td-brand-name, .td-brand-order, .td-brand-des, .td-brand-location").click(function() {
    var brandId = $(this)[0].parentElement.id.replace("brand", "");
    var inputClass = $(this)[0].className.replace("td-", "");
    $("#p-"+inputClass+brandId).addClass("hidden");
    searchInput = $("#"+inputClass+brandId);
    searchInput.removeClass("hidden");
    var strLength = searchInput.val().length * 2;
    searchInput.focus();
    searchInput[0].setSelectionRange(strLength, strLength);
  });

  $(".button-delete-brand").click(function() {
    var brandId = $(this)[0].id.replace("delete-brand", "");
    $("#delete-brand .delete-brand-id").val(brandId);
    $("#delete-brand .delete-brand-name").html($("#p-brand-name"+brandId)[0].innerHTML);
  });

  $("#button-delete-brand-confirm").click(function() {
    var brandId = $("#delete-brand .delete-brand-id").val();
    $.ajax({
      type: "DELETE",
      url: "brands/" + brandId
    }).done(function(response) {
    });
  });

  $(document).on("click","#update-logo",function() {
    var brandId = $(this).data("id");
    // $("#update-logo-brand-id"+brandId).val(brandId);
    $('.update-logo-brand-id').val(brandId);
    $(".heading-logo-brand").html($(this).data("name"));
    $(".preview-logo-brand")[0].src = $(".logo-brand"+brandId)[0].src;
  });

  $('#dataTables-brand').DataTable({
    responsive: true
  });

  $("#upload-logo").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('.preview-logo-brand').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('.preview-logo-brand').attr('src', '/assets/no_preview.png');
    }
  });

  $("#button-update-logo-brand-confirm").click(function() {
    var brandId =  $(".update-logo-brand-id").val();
    var selectedFile = document.getElementById('upload-logo').files[0];
    var formData = new FormData();
    formData.append('image', selectedFile);
    $.ajax({
      url: "/admin/brands/" + brandId,
      method: 'put',
      data: formData,
      processData: false,
      contentType: false
    }).done(function(response) {
      $(".logo-brand"+brandId).attr('src', response.src);
      $('#update-logo-brand').modal('hide');
      $(".update-logo-brand-id").val(null)
    }).fail(function(errors) {
      $("#brand-table .alert-danger-update").removeClass("hidden");
      $('#update-logo-brand').modal('hide');
      $(".update-logo-brand-id").val(null);
    });
  });
});
