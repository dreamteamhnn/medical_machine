$(document).ready(function () {
    $("select").imagepicker();

    // $("#folder_images_attributes_image_url").
    $(".image_cm .preview-img")[0];
});

$(document).on("click",".list-group-folder li",function(e) {
    e.preventDefault()
    window.location.href = "/admin/folders/" + $(this).attr("id").split('-')[1] + "/edit";
});

$(document).on("click","#folder-new",function(e) {
    e.preventDefault()
    createFolder();
});

$(document).on("click","#folder-delete",function(e) {
    e.preventDefault()
    deleteFolder($(this).attr("name").split('-')[1]);
});

$(document).on("change","#folder-name",function(e) {
    e.preventDefault()
    updateFolder($(this).attr("name").split('-')[1], $(this)[0].value);
});

var deleteFolderImage = function(id) {
    $('input[value="'+ id +'"]').remove();
    $('#preview-img-'+id).remove();
}

var updateImage = function(id) {
    $.ajax({
        data: {
            image_id: id
        },
        type: "PATCH",
        url: "/admin/folders/" + id
    }).done(function(response) {

    }).fail(function(errors) {

    });
}

var createFolder = function() {
    $.ajax({
      type: "POST",
      url: "/admin/folders"
    }).done(function(response) {

    }).fail(function(errors) {

    });
}

var updateFolder = function(id, name) {
    $.ajax({
        data: {
            folder: {
                name: name
            }
        },
        type: "PATCH",
        url: "/admin/folders/" + id
    }).done(function(response) {

    }).fail(function(errors) {

    });
}

var deleteFolder = function(id) {
    if (confirm("Bạn muốn xóa thư mục?")) {
        $.ajax({
            type: "DELETE",
            url: "/admin/folders/" + id
        }).done(function(response) {

        }).fail(function(errors) {

        });
    }
    return false;
}
