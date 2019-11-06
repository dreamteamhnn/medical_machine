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

  $("#button-delete-mediums").click(function() {
  	event.preventDefault();
  	
    var searchIDs = $(".media-cb-id input:checkbox:checked").map(function(){
      return $(this).val();
    }).get();
    this.href = url + p + "delete_custom_category_ids=" + searchIDs.join(",");
  });
});
