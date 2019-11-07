$(document).on('turbolinks:load', function(){
  $('#dataTables-doc').DataTable({
    responsive: true
  });

  $(document).on("click", "#document-check-all, #video-check-all", function() {
  	$(".media-cb-id").prop('checked', this.checked);
  });

  var deleteCustomCategoryIds = [];
  $(document).on('click', '.media-cb-id', function () {
    var index = deleteCustomCategoryIds.indexOf(this.value);
    if (index != -1) {
      deleteCustomCategoryIds.splice(index, 1);
    } else {
      deleteCustomCategoryIds.push(this.value);
    }
  });

  $(document).on("click", "#button-delete-documents, #button-delete-videos", function(){

    var type = "&media_type=";
    if ($(this)[0].id == "button-delete-videos") {
      type += "1";
    } else {
      type += "0";
    }

    var url = location.origin + "/" + location.pathname;
    var p = url.substr(url.length - 1) == "?" ? "" : "?";
  	
    var searchIDs = $(".media-cb input:checkbox:checked").map(function(){
      return $(this).val();
    }).get();

    this.href = url + p + "delete_custom_category_ids=" + searchIDs.join(",") + type;
  });
});
