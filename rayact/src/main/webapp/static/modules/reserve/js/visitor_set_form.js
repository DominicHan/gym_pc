$(document).ready(function () {
    $("#addBtn").on('click', function () {
        jQuery.postItems({
            url: ctx+'/reserve/reserveVenueVisitorsSet/form',
            data: {},
            success: function (result) {
                if (result) {
                    $("#periodSetForm").html(result);
                    $("#periodDialogButton").click();
                    $("#periodSetForm .select2").select2({
                        width: '100%'
                    });
                    $('#periodSetForm .icheck').iCheck({
                        checkboxClass: 'icheckbox_square-blue checkbox',
                        radioClass: 'iradio_square-blue'
                    });
                }
            }
        });
    });

    $(".editBtn").on('click', function () {
        var id = $(this).attr("data-id");
        jQuery.postItems({
            url: ctx+'/reserve/reserveVenueVisitorsSet/form',
            data: {id: id},
            success: function (result) {
                if (result) {
                    $("#periodSetForm").html(result);
                    $("#periodDialogButton").click();
                    $("#periodSetForm .select2").select2({
                        width: '100%'
                    });
                    $('#periodSetForm .icheck').iCheck({
                        checkboxClass: 'icheckbox_square-blue checkbox',
                        radioClass: 'iradio_square-blue'
                    });
                }
            }
        });
    });
});