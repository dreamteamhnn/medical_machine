$(document).on('turbolinks:load', function(){
  $(".confirm-tag-save").click(function() {
    var tagId = $(this)[0].name.replace("update-tag", "");
    var tagName = $("#tag-name"+tagId).val();
    var tagUrl = $("#tag-url"+tagId).val();
    $("#tag-name"+tagId).addClass("hidden");
    $("#tag-url"+tagId).addClass("hidden");
    $.ajax({
      data: {
        tag: {
          name: tagName,
          tag_url: tagUrl
        }
      },
      type: "PATCH",
      url: "tags/" + tagId
    }).done(function(response) {
      $("#tag-table .alert-success-update").removeClass("hidden");
      $("#tag-table .alert-danger-update").addClass("hidden");
      $("#p-tag-name"+tagId).removeClass("hidden");
      $("#p-tag-url"+tagId).removeClass("hidden");
      $("#p-tag-name"+tagId)[0].innerHTML = response.name;
      $("#p-tag-url"+tagId)[0].innerHTML = response.tag_url;
    }).fail(function(errors) {
      $("#tag-table .alert-danger-update").removeClass("hidden");
      $("#tag-table .alert-success-update").addClass("hidden");
    });
  });

  $(".td-tag-name, .td-tag-url").click(function() {
    var tagId = $(this)[0].parentElement.id.replace("tag", "");
    var inputClass = $(this)[0].className.replace("td-", "");
    $("#p-"+inputClass+tagId).addClass("hidden");
    searchInput = $("#"+inputClass+tagId);
    searchInput.removeClass("hidden");
    var strLength = searchInput.val().length * 2;
    searchInput.focus();
    searchInput[0].setSelectionRange(strLength, strLength);
  });

  $(".button-delete-tag").click(function() {
    var tagId = $(this)[0].id.replace("delete-tag", "");
    $("#delete-tag .delete-tag-id").val(tagId);
    $("#delete-tag .delete-tag-name").html($("#p-tag-name"+tagId)[0].innerHTML);
  });

  $("#button-delete-tag-confirm").click(function() {
    var tagId = $("#delete-tag .delete-tag-id").val();
    $.ajax({
      type: "DELETE",
      url: "tags/" + tagId
    }).done(function(response) {
    });
  });

  $('#dataTables-tag').DataTable({
    responsive: true
  });
});
