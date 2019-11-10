$(document).on('turbolinks:load', function(){
    $('#table1').DataTable();
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
    }
    $('input[name="category_id"]').val(id);
    $('input[name="order_id"]').val(JSON.stringify(submitArray));
    $('input[name="commit"]').val('save-change');
    $("#multiple-submit").click();
})

var getTableIds = function (){
  var ids = $.map($('#table1').DataTable().rows().data(), function (item) {
    return item[0];
  });
  return ids
}

// var tab1_To_tab2 = function () {
//     $('#table2 .dataTables_empty').parent().parent().remove();
//     var table1 = document.getElementById("table1"),
//         table2 = document.getElementById("table2"),
//         checkboxes = document.getElementsByName("check-tab1");
//      for(var i = 0; i < checkboxes.length; i++)
//          if(checkboxes[i].checked)
//             {
//                 // create new row and cells
//                 var newRow = table2.insertRow(table2.length),
//                     cell1 = newRow.insertCell(0),
//                     cell2 = newRow.insertCell(1),
//                     cell3 = newRow.insertCell(2),
//                     cell4 = newRow.insertCell(3),
//                     cell5 = newRow.insertCell(4);
//                 cell1.innerHTML = table1.rows[i+1].cells[0].innerHTML;
//                 cell2.innerHTML = table1.rows[i+1].cells[1].innerHTML;
//                 cell3.innerHTML = table1.rows[i+1].cells[2].innerHTML;
//                 cell4.innerHTML = table1.rows[i+1].cells[3].innerHTML;
//                 cell5.innerHTML = "<input type='checkbox' name='check-tab2'>";
               
//                 // remove the transfered rows from the first table [table1]
//                 var index = table1.rows[i+1].rowIndex;
//                 table1.deleteRow(index);
//                 // we have deleted some rows so the checkboxes.length have changed
//                 // so we have to decrement the value of i
//                 i--;
//                console.log(checkboxes.length);
//             }
// }


// var tab2_To_tab1 = function () {
//     $('#table1 .dataTables_empty').parent().parent().remove();
//     var table1 = document.getElementById("table1"),
//         table2 = document.getElementById("table2"),
//         checkboxes = document.getElementsByName("check-tab2");
//      for(var i = 0; i < checkboxes.length; i++)
//          if(checkboxes[i].checked)
//             {
//                 // create new row and cells
//                 var newRow = table1.insertRow(table1.length),
//                     cell1 = newRow.insertCell(0),
//                     cell2 = newRow.insertCell(1),
//                     cell3 = newRow.insertCell(2),
//                     cell4 = newRow.insertCell(3),
//                     cell5 = newRow.insertCell(4);
//                 // add values to the cells
//                 cell1.innerHTML = table2.rows[i+1].cells[0].innerHTML;
//                 cell2.innerHTML = table2.rows[i+1].cells[1].innerHTML;
//                 cell3.innerHTML = table2.rows[i+1].cells[2].innerHTML;
//                 cell4.innerHTML = table2.rows[i+1].cells[3].innerHTML;
//                 cell5.innerHTML = "<input type='checkbox' name='check-tab1'>";
               
//                 // remove the transfered rows from the second table [table2]
//                 var index = table2.rows[i+1].rowIndex;
//                 table2.deleteRow(index);
//                 // we have deleted some rows so the checkboxes.length have changed
//                 // so we have to decrement the value of i
//                 i--;
//                console.log(checkboxes.length);
//             }
// }