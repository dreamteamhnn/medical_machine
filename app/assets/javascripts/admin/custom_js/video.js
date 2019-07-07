$(document).on('turbolinks:load', function(){
  $(".confirm-video-save").click(function() {
    var videoId = $(this)[0].name.replace("update-video", "");
    var videoName = $("#video-name"+videoId).val();
    var videoDes = $("#video-des"+videoId).val();
    var videoUrl = $("#video-link"+videoId).val();
    var videoField = $("#video-field"+videoId).val();

    $("#video-name"+videoId).addClass("hidden");
    $("#video-des"+videoId).addClass("hidden");
    $("#video-link"+videoId).addClass("hidden");
    $.ajax({
      data: {
        title: videoName,
        description: videoDes,
        video_url: videoUrl,
        field_id: videoField
      },
      type: "PATCH",
      url: "medias/" + videoId
    }).done(function(response) {
      if (response.status == "update-success") {
        $("#video-table .video-alert-success-update").removeClass("hidden");
        $("#video-table .video-alert-danger-update").addClass("hidden");

        $("#p-video-name"+videoId).removeClass("hidden");
        $("#p-video-des"+videoId).removeClass("hidden");
        $("#p-video-link"+videoId).removeClass("hidden");

        $("#p-video-name"+videoId)[0].innerHTML = response.title;
        $("#p-video-des"+videoId)[0].innerHTML = response.description;
        $("#p-video-link"+videoId)[0].innerHTML = response.video_url;
      } else if (response.status == "update-fail") {
        console.log(response.status);
        $("#video-table .alert-danger-update").removeClass("hidden");
        $("#video-table .alert-success-update").addClass("hidden");
      }
    });
  });

  $(".td-video-name, .td-video-link, .td-video-des").click(function() {
    var videoId = $(this)[0].parentElement.id.replace("video", "");
    var inputClass = $(this)[0].className.replace("td-", "");
    $("#p-"+inputClass+videoId).addClass("hidden");
    searchInput = $("#"+inputClass+videoId);
    searchInput.removeClass("hidden");
    var strLength = searchInput.val().length * 2;
    searchInput.focus();
    searchInput[0].setSelectionRange(strLength, strLength);
  });

  // Delete video

  $(".button-delete-video").click(function() {
    var videoId = $(this)[0].id.replace("delete-video", "");
    $("#delete .delete-video-id").val(videoId);
    $("#delete .delete-video-name").html($("#p-video-name" + videoId)[0].innerHTML);
  });

  $("#button-delete-video-confirm").click(function() {
    var videoId = $("#delete .delete-video-id").val();
    $.ajax({
      type: "DELETE",
      url: "medias/" + videoId
    }).done(function(response) {
    });
  });

  $('#dataTables-video').DataTable({
    responsive: true
  });
});
