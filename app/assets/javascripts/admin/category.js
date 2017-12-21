$(document).on('turbolinks:load', function(){
  $(".btn-add-category, .btn-add-category-sm").click(function() {
    var categoryName = $(this)[0].getAttribute("data-name");
    var categoryId = $(this)[0].getAttribute("data-id");
    $(".parent-category-name").html(categoryName);
    $("#parent_category_id").val(categoryId);
  });

  $(".btn-update-category").click(function() {
    var id = $(this)[0].getAttribute("data-id");
    var name = $(this)[0].getAttribute("data-name");
    var des = $(this)[0].getAttribute("data-des");
    var categoryOrder = $(this)[0].getAttribute("data-category-order");
    var homeBlock = $(this)[0].getAttribute("data-home-block-id");
    var homeOrder = $(this)[0].getAttribute("data-home-order-id");
    var highest = $(this)[0].getAttribute("data-highest");

    $("#category_id").val(id);
    $(".category-title-update").html(name);
    $(".category-name-update").val(name);
    $(".category-des-update").val(des);
    $(".category-order-update").val(categoryOrder);
    $(".category-block-update").val(homeBlock);
    $(".category-order-block-update").val(homeOrder);
    if (highest) {
      $(".category-order-block-update-div")[0].style.display = 'none';
      $(".category-block-update-div")[0].style.display = 'none';
    } else {
      $(".category-order-block-update-div")[0].style.display = 'block';
      $(".category-block-update-div")[0].style.display = 'block';
    }
  });

  $("#button-update-category-confirm").click(function() {
    var id = $("#category_id")[0].value;
    var name = $(".category-name-update")[0].value;
    var des = $(".category-des-update")[0].value;
    var categoryOrder = $(".category-order-update")[0].value;
    var homeBlock = $(".category-block-update")[0].value;
    var homeOrder = $(".category-order-block-update")[0].value;
    $.ajax({
      data: {
        category: {
          name: name,
          description: des,
          category_order: categoryOrder,
          home_block_id: homeBlock,
          home_order_id: homeOrder
        }
      },
      type: "PATCH",
      url: "categories/" + id
    }).done(function(response) {
    })
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
});
