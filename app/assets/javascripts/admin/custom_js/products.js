var selectedProductIds = [];
$(document).on('turbolinks:load', function(){
  
  $("#show-limit").on("change", function(){
    $(this).closest("form").trigger("submit");
  });

  $("#upload-product-image-1, #upload-product-image-2").change(function() {
    var imgId = $(this)[0].id.replace("upload-product-image-", "");
    var input = this;
    var url = $(this).val();
    setPreviewImg(input, url, imgId);
  });

  function onpageLoadImage() {
    loadPreviewImage(1);
    loadPreviewImage(2);
  }

  function loadPreviewImage(index) {
    var img = $("#product-image"+index)[0];
    if (!_.isUndefined(img)) {
      $('#product-new .preview-product-image-'+index).attr('src', img.src);
    } else {
      $('#product-new .preview-product-image-'+index).attr('src', '/preview_no_image.jpg');
    }
  }

  function setPreviewImg(input, url, imgId) {
    var ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
    if (input.files && input.files[0] && (ext == "png" || ext == "jpeg" || ext == "jpg")) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#product-new .preview-product-image-'+imgId).attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    } else {
      $('#product-new .preview-product-image-'+imgId).attr('src', '/preview_no_image.jpg');
    }
  };

  onpageLoadImage();

  // $('#product-table').DataTable({
  //   responsive: true
  // });

  $("#add-param-product").click(function(){
    var row = '<tr>' +
                '<td><input type="text" class="form-control"/></td>' +
                '<td><input type="text" class="form-control"/></td>' +
                '<td><button type="button" class="btn btn-danger delete-param-product">Xóa</button></td>' +
              '</tr>'
    $("#product-parameter-table").append(row);
  });

  $(document).on('click','.delete-param-product',function(){
    $(this).parent().parent()[0].remove();
  });

  $("#confirm-param-product").click(function() {
    var isParamTable = $("#product_is_parameter_table")[0].value;
    if (isParamTable == "true") {
      var oTable = $("#product-parameter-table")[0];
      var rowLength = oTable.rows.length;
      var parameter = [];
      for (i = 1; i < rowLength; i++){
        var oCells = oTable.rows.item(i).cells;
        var key = oCells.item(0).children[0].value;
        var value = oCells.item(1).children[0].value;
        if (key != "") {
          parameter.push(key+":"+value);
        }
      }
      $("#product_parameter").val(parameter.join(";"));
    }
    $(".product-parameter-span")[0].innerHTML = $("#product_parameter").val();
  });

  $("#product_is_parameter_table").change(function() {
    getParameterProduct();
  });

  function getParameterProduct() {
    if (!_.isUndefined($("#product_is_parameter_table")[0])) {
      var isParamTable = $("#product_is_parameter_table")[0].value;
      if (isParamTable == "true") {
        $("#product-parameter-table-div")[0].style.display = 'block';
        $("#product_parameter")[0].classList.add("hidden");
        formatDataParamTable();
      } else {
        $("#product-parameter-table-div")[0].style.display = 'none';
        $("#product_parameter")[0].classList.remove("hidden");
      };
      $(".product-parameter-span")[0].innerHTML = $("#product_parameter").val();
    }
  }

  getParameterProduct();

  function formatDataParamTable() {
    var paramValue = $("#product_parameter").val();
    if (paramValue != "") {
      var paramArr = paramValue.split(";");
      for (var i in paramArr) {
        paramArr[i] = paramArr[i].split(":");
      }
      var isParamTable = $("#product_is_parameter_table")[0].value;
      if (isParamTable == "true") {
        var oTable = $("#product-parameter-table")[0];
        for (var kv in paramArr) {
          var id = parseInt(kv) + 1;
          if (oTable.rows.item(id) == null) {
            var rowHtml = "<tr>"+
                            "<td><input type='text class='form-control'/></td>"+
                            "<td><input type='text' class='form-control'/></td>"+
                            "<td><button type='button' class='btn btn-danger delete-param-product'>Xóa</button></td>"+
                          "</tr>"
            $("#product-parameter-table").find('tbody').append(rowHtml);
          }

          var oCells = oTable.rows.item(id).cells;
          oCells.item(0).children[0].value = paramArr[kv][0];
          oCells.item(1).children[0].value = paramArr[kv][1];
        }
      }
    }
  }

  $("#product-table").on("click", ".button-delete-product", function() {
    $("#button-delete-product-confirm")[0].dataset.id = $(this).data("product-id");
    $("#delete-product .delete-product-name").html($(this).data("product-name"));
  });

  $("#button-delete-product-confirm").click(function() {
    var productId = $(this).data("id");
    $.ajax({
      type: "DELETE",
      url: "products/" + productId
    }).done(function(response) {
    });
  })

  $("#confirm-category-product").click(function(){
    addFieldsFor();
    showSelectedCategory();
  });

  $(".remove-selected-category").click(function(){
    var index = $(this).data("id");
    removeFieldsFor(index);
  });

  $("#product-check-all").click(function(){
    debugger;
  })

  var categoryNames = [];
  function addFieldsFor() {
    categoryNames = [];
    var size = $("#confirm-category-product").data("size");
    for (var j = 0; j < size; j++) {
      var radios = document.getElementsByName("category"+j);
      for (var i = 0, length = radios.length; i < length; i++) {
        if (radios[i].checked) {
          var name = radios[i].labels[0].title;
          var id = radios[i].value;
          var order = $("#category-order"+j)[0].value;
          categoryNames.push(name);
          var parentDiv = $("#category-fields-for")[0];
          parentDiv.innerHTML += fieldsForCategory(j, id, order);
        }
      }
    }
  };

  function removeFieldsFor(index) {
    var categoryElem = document.getElementById('product_product_categories_attributes_'+index+'_category_id');
    var orderElem = document.getElementById('product_product_categories_attributes_'+index+'_list_order');
    if (categoryElem && orderElem && !_.isUndefined(categoryElem) && !_.isUndefined(orderElem)) {
      categoryElem.parentNode.removeChild(categoryElem);
      orderElem.parentNode.removeChild(orderElem);
    }
    $("#category-order"+index)[0].value = "";
    var radios = document.getElementsByName("category"+index);
    for (var i = 0, length = radios.length; i < length; i++) {
      if (radios[i].checked) {
        radios[i].checked = false;
        break;
      }
    }
    return false;
  }

  function fieldsForCategory(index, id, order) {
    return '<input class="form-control hidden" type="number"' +
      'name="product[product_categories_attributes]['+index+'][category_id]"' +
      'id="product_product_categories_attributes_'+index+'_category_id" value="'+id+'">' +
    '<input class="form-control hidden" type="number"' +
      'name="product[product_categories_attributes]['+index+'][list_order]"' +
      'id="product_product_categories_attributes_'+index+'_list_order" value="'+order+'">';
  };

  addFieldsFor();

  function showSelectedCategory() {
    var categoryElem = $(".selected-category-product")[0];
    if (!_.isUndefined(categoryElem)) {
      categoryElem.innerHTML = categoryNames.join(", ");
    }
  }

  showSelectedCategory();

  var fieldNames = [];
  function addFieldFieldsFor() {
    fieldNames = [];
    var checkboxs = document.getElementsByName("product-field");
    for (var i = 0, length = checkboxs.length; i < length; i++) {
      if (checkboxs[i].checked) {
        var name = checkboxs[i].labels[0].title;
        var id = checkboxs[i].value;
        var order = $("#field-order"+i)[0].value;
        fieldNames.push(name);
        var parentDiv = $("#field-fields-for")[0];
        if (!document.getElementById('product_product_fields_attributes_'+i+'_field_id')) {
          parentDiv.innerHTML += fieldsForField(i, id, order);
        }
      } else {
        removeField(i);
      }
    }
  };

  function removeField(i) {
    var fieldElem = document.getElementById('product_product_fields_attributes_'+i+'_field_id');
    var orderElem = document.getElementById('product_product_fields_attributes_'+i+'_list_order');
    if (fieldElem && orderElem && !_.isUndefined(fieldElem) && !_.isUndefined(orderElem)) {
      fieldElem.parentNode.removeChild(fieldElem);
      orderElem.parentNode.removeChild(orderElem);
    }
  }

  function fieldsForField(index, id, order) {
    return '<input class="form-control hidden" type="number"' +
      'name="product[product_fields_attributes]['+index+'][field_id]"' +
      'id="product_product_fields_attributes_'+index+'_field_id" value="'+id+'">' +
    '<input class="form-control hidden" type="number"' +
      'name="product[product_fields_attributes]['+index+'][list_order]"' +
      'id="product_product_fields_attributes_'+index+'_list_order" value="'+order+'">';
  };

  addFieldFieldsFor();

  function showSelectedField() {
    var fieldElem = $(".selected-field-product")[0];
    if (!_.isUndefined(fieldElem)) {
      fieldElem.innerHTML = fieldNames.join(", ");
    }
  }

  showSelectedField();

  $("#confirm-field-product").click(function(){
    addFieldFieldsFor();
    showSelectedField();
  });

  $('#product-table').on('click', '.product-cb-id', function () {
    debugger;
    var index = selectedProductIds.indexOf(this.value);
    if (index != -1) {
      selectedProductIds.splice(index, 1);
    } else {
      selectedProductIds.push(this.value);
    }
  });

  var deleteProductIds = [];

  $('#product-table').on('click', '.product-cb-delete-id', function () {
    var index = deleteProductIds.indexOf(this.value);
    if (index != -1) {
      deleteProductIds.splice(index, 1);
    } else {
      deleteProductIds.push(this.value);
    }
  });

  $("#button-export-products").click(function() {
    var url = removeParam("ids", this.href);
    var p = url.substr(url.length - 1) == "?" ? "" : "?";
    this.href = url + p + "ids=" + selectedProductIds.join(",");
  })

  $("#button-delete-products").click(function() {
    var url = removeParam("ids", this.href);
    var p = url.substr(url.length - 1) == "?" ? "" : "?";
    this.href = url + p + "delete_product_ids=" + selectedProductIds.join(",");
  })

  //video
  var videoNames = [];
  function addVideoFieldsFor() {
    videoNames = [];
    var checkboxs = document.getElementsByName("product-video");
    for (var i = 0, length = checkboxs.length; i < length; i++) {
      if (checkboxs[i].checked) {
        var name = checkboxs[i].labels[0].title;
        var id = checkboxs[i].value;
        videoNames.push(name);
        var parentDiv = $("#video-fields-for")[0];
        if (!document.getElementById('product_product_media_relations_attributes_'+i+'_medium_id')) {
          parentDiv.innerHTML += fieldForVideo(i, id);
        }
      } else {
        removeVideo(i);
      }
    }
  };

  function removeVideo(i) {
    var videoElem = document.getElementById('product_product_media_relations_attributes_'+i+'_medium_id');
    if (videoElem && !_.isUndefined(videoElem)) {
      videoElem.parentNode.removeChild(videoElem);
    }
  }

  function fieldForVideo(index, id) {
    return '<input class="form-control hidden" type="number"' +
      'name="product[product_media_relations_attributes]['+index+'][medium_id]"' +
      'id="product_product_media_relations_attributes_'+index+'_medium_id" value="'+id+'">';
  };

  addVideoFieldsFor();

  $("#confirm-video-product").click(function(){
    addVideoFieldsFor();
  });

  //document
  var documentNames = [];
  function adddocumentFieldsFor() {
    documentNames = [];
    var checkboxs = document.getElementsByName("product-document");
    for (var i = 0, length = checkboxs.length; i < length; i++) {
      if (checkboxs[i].checked) {
        var name = checkboxs[i].labels[0].title;
        var id = checkboxs[i].value;
        documentNames.push(name);
        var index = 100 + i;
        var parentDiv = $("#document-fields-for")[0];
        if (!document.getElementById('product_product_media_relations_attributes_'+index+'_medium_id')) {
          parentDiv.innerHTML += fieldFordocument(index, id);
        }
      } else {
        removedocument(i);
      }
    }
  };

  function removedocument(i) {
    var documentElem = document.getElementById('product_product_media_relations_attributes_'+i+'_medium_id');
    if (documentElem && !_.isUndefined(documentElem)) {
      documentElem.parentNode.removeChild(documentElem);
    }
  }

  function fieldFordocument(index, id) {
    return '<input class="form-control hidden" type="number"' +
      'name="product[product_media_relations_attributes]['+index+'][medium_id]"' +
      'id="product_product_media_relations_attributes_'+index+'_medium_id" value="'+id+'">';
  };

  adddocumentFieldsFor();

  $("#confirm-document-product").click(function(){
    adddocumentFieldsFor();
  });

});

var productQuickSave = [];

var changePName = function(id) {
  var obj = productQuickSave.find(function(name){return name.id === id});
  var updatedValue = $("#p-name-" + id).val();
  if (!_.isUndefined(obj)) {
    obj["name"] = updatedValue;
  } else {
    productQuickSave.push({id: id, name: updatedValue})
  }
}

var changePOrder = function(id) {
  var obj = productQuickSave.find(function(name){return name.id === id});
  var updatedValue = $("#p-order-" + id).val();
  if (!_.isUndefined(obj)) {
    obj["order"] = updatedValue;
  } else {
    productQuickSave.push({id: id, order: updatedValue})
  }
}

var changePModel = function(id) {
  var obj = productQuickSave.find(function(name){return name.id === id});
  var updatedValue = $("#p-model-" + id).val();
  if (!_.isUndefined(obj)) {
    obj["model"] = updatedValue;
  } else {
    productQuickSave.push({id: id, model: updatedValue})
  }
}

var changePPrice = function(id) {
  var obj = productQuickSave.find(function(name){return name.id === id});
  var updatedValue = $("#p-price-" + id).val();
  if (!_.isUndefined(obj)) {
    obj["price"] = updatedValue;
  } else {
    productQuickSave.push({id: id, price: updatedValue})
  }
}

var changePShortDesc = function(id) {
  var obj = productQuickSave.find(function(name){return name.id === id});
  var updatedValue = $("#p-short-description-" + id).val();
  if (!_.isUndefined(obj)) {
    obj["short_description"] = updatedValue;
  } else {
    productQuickSave.push({id: id, short_description: updatedValue})
  }
}

var quickSave = function(id) {
  var sendData = productQuickSave.find(x => x.id === id);
  if (!_.isUndefined(sendData)) {
    $.ajax({
      url: '/admin/product_quick_save/' + id,
      method: 'put',
      dataType: "json",
      data: {
        data: JSON.stringify(sendData)
      },
      success: function(result,status,xhr) {
        alert("Sửa nhanh thành công!");
      },
      error: function(xhr,status,error) {
        alert("Lỗi...!")
      }
    });
  }
}

function removeParam(key, sourceURL) {
  var rtn = sourceURL.split("?")[0],
    param,
    params_arr = [],
    queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
  if (queryString !== "") {
    params_arr = queryString.split("&");
    for (var i = params_arr.length - 1; i >= 0; i -= 1) {
        param = params_arr[i].split("=")[0];
        if (param === key) {
            params_arr.splice(i, 1);
        }
    }
    rtn = rtn + "?" + params_arr.join("&");
  }
  return rtn;
}
