$(document).ready(function () {
    $('.icheck').iCheck({
        checkboxClass: 'icheckbox_square-blue checkbox',
        radioClass: 'iradio_square-blue'
    });
    //常规价格设定
    $("#globalPrice").on('click', function () {
        //retail member group
        var marketPrice = $("#marketPrice").val();//市场价
        var memberPrice = $("#memberPrice").val();//会员价
        $.addWorkPrice("1", marketPrice, memberPrice);//周一至周五
        $.addWorkPrice("2", marketPrice, memberPrice);//周六
        $.addWorkPrice("3", marketPrice, memberPrice);//周日
    });
    jQuery.addWorkPrice = function (type, marketPrice, memberPrice) {
        $.each($("input[data='" + type + "-1']"), function () {
            var t = $(this);
            t.val(marketPrice);
        });
        $.each($("input[data='" + type + "-2']"), function () {
            var t = $(this);
            t.val(memberPrice);
        });
    };
});