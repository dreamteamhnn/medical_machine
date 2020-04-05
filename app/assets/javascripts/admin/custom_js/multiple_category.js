$(document).on('turbolinks:load', function(){
    $('#table1').DataTable( {
        "order": [[ 2, "asc" ]]
    } );;
    $('#table2').DataTable();
    $('.dataTables_length').addClass('bs-select');
} );

var selectedIds = [];
var unSelectedIds = [];

var handleClickUnselected = function(id) {
    if (unSelectedIds.includes(id)) {
        var index = unSelectedIds.indexOf(id);
        unSelectedIds.splice(index, 1);
    } else {
        unSelectedIds.push(id);
    }
    $('input:hidden[name=unselectedIds]').val(unSelectedIds);
}

var handleClickSelected = function(id) {
    if (selectedIds.includes(id)) {
        var index = selectedIds.indexOf(id);
        selectedIds.splice(index, 1);
    } else {
        selectedIds.push(id)
    }
    $('input:hidden[name=selectedIds]').val(selectedIds);
}

var tab1_To_tab2 = function (id) {
    $('input[name="category_id"]').val(id);
    $('input[name="commit"]').val('left-to-right');
    $("#multiple-submit").click();
}

var tab2_To_tab1 = function (id) {
    $('input[name="category_id"]').val(id);
    $('input[name="commit"]').val('right-to-left');
    $("#multiple-submit").click();
}

$(document).on('change', '#multiple-category-select', function() {
    window.location.href = $("#multiple-category-select").val();
});

$(document).on('click', "#save-change", function() {
    var data = $('#table1').DataTable().$('input').serialize().split("&");
    var submitArray = [];
    var allIds = getTableIds();
    for (var i = 0; i < allIds.length; i++) {
        submitArray.push({id: allIds[i], order: data[i].replace("selected-order=", "")})
    }
    var url = $("#multiple-category-select").val();
    var id = null;
    if (url != null) {
        id = url[0].split("=")[1];
    } else {
        id = window.location.href.split("=")[1];
    }

    if (id == undefined) {
        id = 1;
    }
    $('input[name="category_id"]').val(id);
    $('input[name="order_id"]').val(JSON.stringify(submitArray));
    $('input[name="commit"]').val('save-change');

    unSelectedIds = []
    selectedIds = []
    $('input:hidden[name=selectedIds]').val(selectedIds);
    $('input:hidden[name=unselectedIds]').val(unSelectedIds);

    $("#multiple-submit").click();
})

var getTableIds = function (){
  var ids = $.map($('#table1').DataTable().rows().data(), function (item) {
    return item[0];
  });
  return ids
}

$(document).on('turbolinks:load', function(){
    $("#multiple-category-check-all").click(function(){
        $(".multiple-category-cb-id").prop('checked', this.checked);

        var allSelectedIds = $(".multiple-category-cb-1 input:checkbox:checked").map(function(){
          return $(this).val();
        }).get();

        $('input:hidden[name=selectedIds]').val(allSelectedIds);
    })

    $("#multiple-category-check-all-2").click(function(){
        $(".multiple-category-cb-id-2").prop('checked', this.checked);

        var unAllSelectedIds = $(".multiple-category-cb-2 input:checkbox:checked").map(function(){
          return $(this).val();
        }).get();

        $('input:hidden[name=unselectedIds]').val(unAllSelectedIds);
    })
});
