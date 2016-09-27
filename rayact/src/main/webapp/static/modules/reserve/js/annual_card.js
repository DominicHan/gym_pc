function annualCardSellForm(id,periodPrice) {
    jQuery.postItems({
        url: ctx + '/reserve/annualCardMember/annualCardSellForm',
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
function annualCardSell(){
    var id=$("#id").val();
    var rechargeVolume=$("#rechargeVolume").val().trim();
    var remarks=$("#remarks").val().trim();
    if(rechargeVolume==null||rechargeVolume==""||rechargeVolume==undefined){
        errorLoding("请输入充值金额");
        return;
    }
    if(isNaN(rechargeVolume)){
        errorLoding("充值金额必须为小数");
        return;
    }
    var payType = $('#payType input:radio:checked').val();
    if(payType=="" || payType==null || payType==undefined){
        errorLoding("请选择支付类型");
        return;
    }
    jQuery.postItems({
        url: ctx + '/reserve/annualCardMember/annualCardSell',
        data: {id: id,rechargeVolume:rechargeVolume,payType:payType,remarks:remarks},
        success: function () {
            successLoding("充值成功");
            location.reload(true);
        }
    });
}