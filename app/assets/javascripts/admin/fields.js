$(document).on('turbolinks:load', function(){
  $(".confirm-field-save").click(function() {
    var fieldId = $(this)[0].name.replace("update-field", "");
    var fieldName = $("#field-name"+fieldId).val();
    var fieldOrder = $("#field-order"+fieldId).val();
    var fieldDes = $("#field-des"+fieldId).val();
    $("#field-name"+fieldId).addClass("hidden");
    $("#field-order"+fieldId).addClass("hidden");
    $("#field-des"+fieldId).addClass("hidden");
    $.ajax({
      data: {
        name: fieldName,
        menu_order: fieldOrder,
        description: fieldDes
      },
      type: "PATCH",
      url: "fields/" + fieldId
    }).done(function(response) {
      $("#field-table .alert-success-update").removeClass("hidden");
      $("#field-table .alert-danger-update").addClass("hidden");
      $("#p-field-name"+fieldId).removeClass("hidden");
      $("#p-field-order"+fieldId).removeClass("hidden");
      $("#p-field-des"+fieldId).removeClass("hidden");
      $("#p-field-name"+fieldId)[0].innerHTML = response.name;
      $("#p-field-order"+fieldId)[0].innerHTML = response.menu_order;
      $("#p-field-des"+fieldId)[0].innerHTML = response.description;
    }).fail(function(errors) {
      $("#field-table .alert-danger-update").removeClass("hidden");
      $("#field-table .alert-success-update").addClass("hidden");
    });
  });

  $(".td-field-name, .td-field-order").click(function() {
    var fieldId = $(this)[0].parentElement.id.replace("field", "");
    var inputClass = $(this)[0].className.replace("td-", "");
    $("#p-"+inputClass+fieldId).addClass("hidden");
    searchInput = $("#"+inputClass+fieldId);
    searchInput.removeClass("hidden");
    var strLength = searchInput.val().length * 2;
    searchInput.focus();
    searchInput[0].setSelectionRange(strLength, strLength);
  });

  $('.td-field-des').click(function() {
    var fieldId = $(this)[0].parentElement.id.replace("field", "");
    var searchInput = $("#field-des"+fieldId);
    $('#ckeditor-modal').attr('data-field-id', fieldId);
    CKEDITOR.instances['tmp-ckeditor-content'].setData(searchInput.val());
    $('#ckeditor-modal').modal('show');
    $("#p-field-des"+fieldId).addClass("hidden");
    searchInput.removeClass("hidden");
  });

  $('#apply-content-btn').click(function() {
    var fieldDes = CKEDITOR.instances['tmp-ckeditor-content'].getData();
    var fieldId = $('#ckeditor-modal').attr('data-field-id');
    var searchInput = $("#field-des"+fieldId);
    searchInput.val(fieldDes);
    $('#ckeditor-modal').modal('hide');
  });

  $(".button-delete-field").click(function() {
    var fieldId = $(this)[0].id.replace("delete-field", "");
    $("#delete .delete-field-id").val(fieldId);
    $("#delete .delete-field-name").html($("#p-field-name"+fieldId)[0].innerHTML);
  });

  $("#button-delete-field-confirm").click(function() {
    var fieldId = $("#delete .delete-field-id").val();
    $.ajax({
      type: "DELETE",
      url: "fields/" + fieldId
    }).done(function(response) {
      $("#field-table .alert-success-delete").removeClass("hidden");
      $("#field-table .alert-danger-delete").addClass("hidden");
      $('#delete').modal('hide');
      window.location.reload(true);
    }).fail(function(errors) {
      $("#field-table .alert-danger-delete").removeClass("hidden");
      $("#field-table .alert-success-delete").addClass("hidden");
    });
  });

  $("#button-create-field-confirm").click(function() {
    var fieldName = $("#create .field-name-create").val();
    var fieldOrder = $("#create .field-order-create").val();
    var fieldDes = CKEDITOR.instances['field-des-create'].getData();
    $.ajax({
      data: {
        name: fieldName,
        menu_order: fieldOrder,
        description: fieldDes
      },
      type: "POST",
      url: "fields",
      dataSrc: ""
    }).done(function(response) {
      $("#field-table .alert-success-create").removeClass("hidden");
      $("#field-table .alert-danger-create").addClass("hidden");
      // window.location.reload(true);
      window.location.reload(true);
    }).fail(function(errors) {
      $("#field-table .alert-danger-create").removeClass("hidden");
      $("#field-table .alert-success-create").addClass("hidden");
    });
  });

  $('#dataTables-example').DataTable({
    responsive: true
  });

  var deleteFieldIds = [];
  $('#dataTables-example').on('click', '.field-cb-delete-id', function () {
    var index = deleteFieldIds.indexOf(this.value);
    if (index != -1) {
      deleteFieldIds.splice(index, 1);
    } else {
      deleteFieldIds.push(this.value);
    }
  });

  $("#button-delete-fields").click(function() {
    var url = removeParam("ids", this.href);
    var p = url.substr(url.length - 1) == "?" ? "" : "?";
    this.href = url + p + "delete_field_ids=" + deleteFieldIds.join(",");
  });
});
