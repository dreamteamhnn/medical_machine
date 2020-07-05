$(document).on('turbolinks:load', function(){
  $(".btn-add-category, .btn-add-category-sm").click(function() {
    var categoryName = $(this)[0].getAttribute("data-name");
    var categoryId = $(this)[0].getAttribute("data-id");
    $(".parent-category-name").html(categoryName);
    $("#parent_category_id").val(categoryId);
  });

  $(".btn-update-category").click(function() {
    var img = $(this)[0].getAttribute("data-img-url");
    var id = $(this)[0].getAttribute("data-id");
    var slug = $(this)[0].getAttribute("data-slug");
    var name = $(this)[0].getAttribute("data-name");
    var des = $(this)[0].getAttribute("data-des");
    var categoryOrder = $(this)[0].getAttribute("data-category-order");
    var homeBlock = $(this)[0].getAttribute("data-home-block-id");
    var homeOrder = $(this)[0].getAttribute("data-home-order-id");
    var highest = $(this)[0].getAttribute("data-highest");
    var metaDescription = $(this)[0].getAttribute("data-meta-description");
    var metaKeyword = $(this)[0].getAttribute("data-meta-keyword");

    $(".edit_category").attr('id', 'edit_category_' + id);
    $(".edit_category").attr('action', '/admin/categories/' + slug);

    $("#category_id").val(id);
    $(".category-title-update").html(name);
    $(".category-name-update").val(name);
    if (img == "") {
      $("#update-category .preview-category-image").attr("src", img);
    } else {
      $("#update-category .preview-category-image").attr("src", img);
    }
    $(".category-des-update").val("aaaaaaa");
    CKEDITOR.instances['category-des-update'].setData(des);
    $(".category-order-update").val(categoryOrder);
    $(".category-block-update").val(homeBlock);
    $(".category-order-block-update").val(homeOrder);
    $(".category-meta-description").val(metaDescription);
    $(".category-meta-keyword").val(metaKeyword);
    if (highest) {
      $(".category-order-block-update-div")[0].style.display = 'none';
      $(".category-block-update-div")[0].style.display = 'none';
    } else {
      $(".category-order-block-update-div")[0].style.display = 'block';
      $(".category-block-update-div")[0].style.display = 'block';
    }
  });

  $("#button-update-category-confirm").click(function() {
    $(".edit_category").submit();
    // var id = $("#category_id")[0].value;
    // var img = $(".category-img-update")[0].value;
    // var name = $(".category-name-update")[0].value;
    // var des = CKEDITOR.instances['category-des-update'].getData();
    // var categoryOrder = $(".category-order-update")[0].value;
    // var homeBlock = $(".category-block-update")[0].value;
    // var homeOrder = $(".category-order-block-update")[0].value;
    // $.ajax({
    //   data: {
    //     category: {
    //       name: name,
    //       description: des,
    //       category_order: categoryOrder,
    //       home_block_id: homeBlock,
    //       home_order_id: homeOrder,
    //       img: img
    //     }
    //   },
    //   type: "PATCH",
    //   url: "categories/" + id
    // }).done(function(response) {
    // })
  });

  $(".btn-delete-category").click(function() {
    var id = $(this)[0].getAttribute("data-id");
    var name = $(this)[0].getAttribute("data-name");
    $(".delete-category-name").html(name);
    $("#delete_category_id").val(id);
  });

  $("#button-delete-category-confirm").click(function() {
    var id = $("#delete_category_id")[0].value;
    $.ajax({
      type: "DELETE",
      url: "categories/" + id
    }).done(function(response) {
    });
  });

  $("#upload-category-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#create-category .preview-category-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#create-category .preview-category-image').attr('src', '/preview_no_image.jpg');
    }
  });

  $("#update-category-image").change(function() {
    var input = this;
    var url = $(this).val();
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg"))
     {
        var reader = new FileReader();
        reader.onload = function (e) {
           $('#update-category .preview-category-image').attr('src', e.target.result);
        }
       reader.readAsDataURL(input.files[0]);
    }
    else
    {
      $('#update-category .preview-category-image').attr('src', '/preview_no_image.jpg');
    }
  });
});
