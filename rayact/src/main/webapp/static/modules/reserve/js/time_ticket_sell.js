$.ajaxSetup({
    async : false
});
$("#isMember").on('ifChecked', function () {
    $("#memberId").removeAttr("disabled");
    $("#consPrice").attr("readonly", "readonly");
    $("#userName").attr("readonly", "readonly");
    $("#consMobile").attr("readonly", "readonly");
    $(".memberSelect").show();
    $("input[name='payType'][value='1']").iCheck('check');
    $("input[name='payType'][value='1']").iCheck('enable');
});

$("#nMember").on('ifChecked', function () {
    $("#memberId").attr("disabled", "disabled");
    $("#consPrice").removeAttr("readonly");
    $("#userName").removeAttr("readonly");
    $("#consMobile").removeAttr("readonly");
    $("#memberId").val("");
    $("#s2id_memberId").find(".select2-chosen").html("--请选择--");
    $("#userName").attr("value", "");
    $("#consMobile").attr("value", "");
    $("input[name='payType'][value='2']").iCheck('check');
    $("input[name='payType'][value='1']").iCheck('disable');
});

$("#memberId").on('change', function () {
    var text = $(this).find("option:selected").text();
    var mobile = text.split('-')[0];
    var username = text.split('-')[1];
    $("#userName").attr("value", username);
    $("#consMobile").attr("value", mobile);
});

$("#startTime").on('change', function () {
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();
    var start = startTime.split(':')[0];
    var end = endTime.split(':')[0];
    var cnt = end - start;
    $("#collectCount").val(cnt);
    var orderTotal = $("#ticketPrice").val() * cnt;
    var collectPrice = $("#ticketPrice").val() * cnt;
    $("#orderTotal").attr("value", orderTotal);
    $("#collectPrice").attr("value", collectPrice);
});
$("#endTime").on('change', function () {
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();
    var start = startTime.split(':')[0];
    var end = endTime.split(':')[0];
    var cnt = end - start;
    $("#collectCount").val(cnt);
    var orderTotal = $("#ticketPrice").val() * cnt;
    var collectPrice = $("#ticketPrice").val() * cnt;
    $("#orderTotal").attr("value", orderTotal);
    $("#collectPrice").attr("value", collectPrice);
});

$("#saveBtn").on('click', function () {
    var memberType = $("#memberType input:radio:checked").val();
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();
    var checkResult=true;
    if (startTime == endTime) {
        formLoding('开始时间应小于结束时间');
        checkResult=false;
        return false;
    }
    if (memberType == '2') {
        var memberId = $("#memberId").val();
        if (!memberId) {
            errorLoding("请选择会员");
            checkResult=false;
            return false;
        }
    }
    var collectPrice = $("#collectPrice").val();
    if (isNaN(collectPrice)) {
        errorLoding("支付金额必须为数字");
        checkResult=false;
        return false;
    }
    $.postItems({
        url: ctx + '/reserve/field/checkTime',
        data: {startTime: startTime, endTime: endTime},
        success: function (result) {
            var values= eval("("+result+")");
            if (values.rs!="1") {
                formLoding(values.msg);
                checkResult=false;
            }
        }
    });
    var checkFlag = false;
    if(checkResult){
        var formJson = $("#formBean").serializeArray();
        jQuery.postItems({
            url: ctx + '/reserve/reserveVenueOrder/checkSave?random=' + Math.random(),
            data: formJson,
            success: function (result) {
                result = $.parseJSON(result);
                if (result.status == true) {
                    checkFlag = true;
                } else {
                    formLoding(result.msg);
                    return;
                }
            }
        });
    }
    if (checkFlag == true) {
        jQuery.postItems({
            url: ctx + '/reserve/reserveVenueOrder/save?random=' + Math.random(),
            data: formJson,
            success: function (result) {
                result = $.parseJSON(result);
                if (result.status) {
                    $("#closeBtn").click();
                }
                formLoding(result.msg);
            }
        });
    }
});


jQuery.addPrice = function (price, orderPrice, count) {
    if (price == '' || price == undefined) {
        price = 0;
    }
    if (orderPrice == '' || orderPrice == undefined) {
        orderPrice = 0;
    }
    if (count == '' || count == undefined) {
        count = 1;
    }
    var orderTotal = price * count + orderPrice * count;
    $("#orderTotal").text(orderTotal);
    $("#collectPrice").attr("value", orderTotal);
};

//数量改变事件
$("#collectCount").on('keyup', function () {
    var t = $(this);
    var r = /^[0-9]*[1-9][0-9]*$/
    var value = t.val();
    if (value == '') {
        value = 1;
    }
    if (r.test(value) == false) {
        $("#collectCount").val("1");
    } else {
        var price = $("#tutorId").find("option:selected").attr("data-price");
        var orderPrice = $("#orderPrice").val();
        $.addPrice(price, orderPrice, value);
    }
});