function addTime(id,periodPrice) {
    jQuery.postItems({
        url: ctx + '/reserve/timeCardMember/addTimeForm',
        data: {
            id: id,
            periodPrice:periodPrice
        },
        success: function (result) {
            $("#addTutorPeriodDialogButton").click();
            $("#addTutorPeriodForm").html(result);
        }
    });
}
function prePayment(memberId) {
    jQuery.postItems({
        url: ctx + '/reserve/reserveTimeCardPrepayment/list',
        data: {memberId: memberId,type:2},
        success: function (result) {
            $("#prePaymentDialogButton").click();
            $("#prePaymentDialogForm").html(result);
        }
    });
}
function timeCardRechargeAddTime(){
    var id=$("#id").val();
    var rechargeVolume=$("#rechargeVolume").val().trim();
    var time=$("#time").val().trim();
    var remarks=$("#remarks").val().trim();
    if(rechargeVolume==null||rechargeVolume==""||rechargeVolume==undefined){
        errorLoding("请输入充值金额");
        return;
    }
    if(isNaN(rechargeVolume)){
        errorLoding("充值金额必须为小数");
        return;
    }
    if(time==null||time==""||time==undefined){
        errorLoding("请输入次数");
        return;
    }
    if(isNaN(time)){
        errorLoding("次数必须为数字");
        return;
    }
    var payType = $('#payType input:radio:checked').val();
    if(payType=="" || payType==null || payType==undefined){
        errorLoding("请选择支付类型");
        return;
    }
    jQuery.postItems({
        url: ctx + '/reserve/tutorTimeCardMember/addTime',
        data: {id: id,rechargeVolume:rechargeVolume,time:time,payType:payType,remarks:remarks},
        success: function () {
            successLoding("充值成功");
            location.reload(true);
        }
    });
}