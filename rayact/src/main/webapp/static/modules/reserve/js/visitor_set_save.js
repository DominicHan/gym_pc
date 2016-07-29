function  save(){
    var reserveVenueId = $("#reserveVenueId").val();
    if (!reserveVenueId) {
        formLoding("请选择健身房");
        return;
    }
    var projectId = $("#projectId").val().trim();
    if (!projectId) {
        formLoding("请选择项目");
        return;
    }

    var data = $("#period_name").val().trim();
    if (data == '') {
        formLoding("请输入课时名称");
        return;
    }
    var period_price = $("#period_price").val().trim();
    if (!period_price) {
        formLoding("请输入价格");
        return;
    }
    if (isNaN(period_price)) {
        formLoding("价格必须为数字");
        return;
    }
    var formJson = $("#formBean").serializeArray();
    jQuery.postItems({
        url: ctx + '/reserve/reserveVenueVisitorsSet/save',
        data: formJson,
        success: function (result) {
            if (result == 'success') {
                location.reload();
            } else {
                formLoding('保存出错!');
            }
        }
    });
};