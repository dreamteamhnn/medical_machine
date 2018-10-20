$(document).on('turbolinks:load', function(){
    $("#mytable #checkall").click(function () {
        if ($("#mytable #checkall").is(':checked')) {
            $("#mytable input[type=checkbox]").each(function () {
                $(this).prop("checked", true);
            });

        } else {
            $("#mytable input[type=checkbox]").each(function () {
                $(this).prop("checked", false);
            });
        }
    });

    $("[data-toggle=tooltip]").tooltip();
    $('.selectpicker').selectpicker();
    $('#save-home-category-btn').click(function(){
        $('#home-top').val($('#home-top-select').val());
        $('#home-bottom').val($('#home-bottom-select').val());
        $('#home-categories').submit();
    });
});
