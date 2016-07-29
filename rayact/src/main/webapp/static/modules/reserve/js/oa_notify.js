/**
 * Created by lenovo on 2016/1/11.
 */
$(document).ready(function () {
    jQuery.postItems({
        url: ctx + '/oa/oaNotify/self/count',
        data: {},
        success: function (result) {
            if(result!="0"){
                $("#oaNotify").append(" ("+result+")");
                $("#selfNotify").append(" ("+result+")");
            }
        }
    });
})