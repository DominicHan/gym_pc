<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>场地预定</title>
    <meta name="referrer" content="always"/>
    <meta charset='utf-8'/>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="${ctxStatic}/cleanzone/js/bootstrap/dist/css/bootstrap.css" rel="stylesheet"/>
    <script src="${ctxStatic}/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <style type="text/css">
        body {
            font-family: -apple-system, Helvetica, sans-serif;
            font-size: 14px;
            width: 100%;
            text-align: center;
            background: #F5F5F5;
        }

        .table-chang {
            overflow: hidden;
            border-collapse: separate;
            border-spacing: 5px;
            margin: 0 auto;
        }

        .table-chang thead th {
            font-size: 12px;
            border: 1px;
            background: transparent
        }

        .table-chang th {
            width: 150px;
            min-width: 150px;
            max-width: 200px;
            height: 30px;
            font-weight: normal;
            ext-align: center;
            color: #323232
        }

        .table-chang td {
            width: 150px;
            min-width: 150px;
            max-width: 200px;
            height: 30px;
            background: #FFF;
            text-align: center;
            color: #fff;
            font-size: 15px;
            padding: 0px;
            border: 1px solid #FFFFFF;
        }

        .table-chang td a {
            display: block;
            width: 100%;
            height: 100%;
        }

        .table-chang td.access {
            background: #FFF;
            color: #A62A04;
            border: 1px dashed #A62A04;
        }

        .table-chang td.unavailable {
            background: #F0F0F0;
            color: #C8C8C8
        }

        .table-chang td.unPayed {
            background: #F0860C;
        }

        .table-chang td div.unPayed {
            background: #F0860C;
        }

        .button_submit {
            display: inline-block;
            width: 100%;
            height: 50px;
            padding: 10px;
            margin-bottom: 0;
            color: white;
            font-size: 20px;
            text-align: center;
            vertical-align: middle;
            cursor: pointer;
            background-color: #990707;
            border: 0px;
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<div style="background-color:#fff;padding:10px;border-bottom:1px solid rgb(178,178,178);">
    <table border="0" width="100%">
        <tbody>
        <tr>
            <td onclick="javascript:history.back(-1)" width="30px"><img
                    src="${ctxStatic}/images/weiXin_return.png"
                    style="margin-bottom:-2px;" height="22px"></td>
            <td align="center" valign="middle">
                <div style="padding:5px 0"><img
                        src="${ctxStatic}/images/weiXin_logo.png"
                        style="display:block" height="16px"></div>
            </td>
            <td width="30px">&nbsp;<a href="${ctx}/logout"><img
                    src="${ctxStatic}/images/weiXin_logout.png" style="margin-bottom:-2px;"
                    height="22px"></a></td>
        </tr>
        </tbody>
    </table>
</div>
<div style="margin: 0 auto;width: 310px">
    <form:form id="searchForm"
               action="${ctx}/app/reserve/timeList"
               method="post">
        <input name="filedId" value="${filedId}" type="hidden">
        <div style="width: 150px;float: left;">
            <input value="${consDate}" style="width: 100%"
                   id="consDate" name="consDate" type="text"
                   class="input-small form-control Wdate"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
        </div>
        <div style="width: 150px;float: right;">
            <input id="btnSubmit" class="btn btn-primary pull-right" type="submit"
                   value="查询"/>
        </div>
    </form:form>
</div>
<table class="table-chang">
    <%-- 遍历所有场地开始--%>
    <c:forEach items="${times}" var="t" varStatus="varStatus">
    <j:if test="${varStatus.index%2==0}">
    <tr>
        </j:if>
            <%-- 横坐标：场地状态--%>
        <c:forEach items="${venueFieldPriceList}" var="field">
            <c:set var="status" value="0"/>
            <%--遍历单个场地的时间、价格组成的Jason 获得状态--%>
        <c:forEach items="${field.timePriceList}" var="tp">
            <%--场地jason的时间与横坐标的时间一致 --%>
        <j:if test="${t eq tp.time}">
            <%--设置单个场地 时间T 的状态--%>
            <c:set var="status" value="${tp.status}"/>
            <c:set var="time" value="${tp.time}"/>
            <%-- A场地 B时间 的状态 结束--%>
        </j:if>
        </c:forEach>


            <%--设置td的class--%>
        <j:if test="${'0' eq status}">
            <c:set var="tdClass" value="reserveTd access"/>
        </j:if>
        <j:if test="${!('0' eq status)}">
            <c:set var="tdClass" value="reserveTd unavailable"/>
        </j:if>
            <%--设置td的class end--%>

            <%-- 场地 B时间 的状态展示--%>

        <td status="${status}"
            class="${tdClass}"
            data-field-id="${field.fieldId}"
            data-field-name="${field.fieldName}"
            data-time="${t}"
        >
            <j:if test="${'0' eq status}">
                ${time}
            </j:if>
            <j:if test="${!('0' eq status)}">
                <span>已预约</span>
            </j:if>
        </td>
            <%-- A场地 B时间 的状态展示 结束--%>
        </c:forEach>
            <%-- 横坐标：时间 结束--%>
            <%-- 纵坐标：场地 结束--%>
        </c:forEach>
        <%-- 遍历所有全场 场地结束--%>
</table>
<div id="unPayed" class="row" style="display: none">
</div>
<form id="orderForm">
    <input name="venueId" value="${venueId}" type="hidden"/>
    <input name="consDate" value="${consDate}" type="hidden"/>
    <div style="margin:20px auto 20px auto; width:300px;">
        <input type="button" class="button_submit" onclick="filedSelectJson()" value="提交">
        </input>
    </div>
</form>

<script type="text/javascript" src="${ctxStatic}/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/jeesite.js"></script>
<script>
    //保存数据
    $.ajaxSetup({
        async: false
    });
    $(document).ready(function () {
        //-------预定---------
        $(".reserveTd").on('mousedown', function () {
            var fieldId = $(this).attr("data-field-id");
            var fieldName = $(this).attr("data-field-name");
            var price = $(this).attr("data-price");
            var time = $(this).attr("data-time");
            var startTime = time.substring(0, 5);
            var endTime = time.substring(6, 12);
            var time1 = time.substring(0, 2);
            var time2 = time.substring(3, 5);
            var time3 = time.substring(6, 8);
            var time4 = time.substring(9, 11);
            var timeId = time1 + time2 + time3 + time4;
            var tr_id = fieldId + timeId;
            var order_item_id = tr_id + 'item';
            if ($(this).hasClass("unavailable")) {
                return;
            }
            var phone = $("#phone").val();
            var orderId = null;
            if ($(this).hasClass("access")) {//预定
                var index = $("#orderForm div").length;
                if (orderId == '' || orderId == null || orderId == undefined) {
                    $(this).removeClass("access");
                    $(this).addClass("unPayed");
                    var s = '<div id=' + tr_id + ' class="col-xs-1" style="height:60px;margin:5px;border: 1px solid #009ff0;border-radius:5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;-o-border-radius: 5px;"> ' +
                            '<div class="row text-center" style="height:30px;background-color:#009ff0;font-size:15px;color:#fff;line-height: 30px">' + time + '</div>' +
                            '<div class="row text-center" style="height:30px;font-size:15px;line-height: 30px">' + fieldName + '</div></div>';
                    $("#unPayed").append(s);
                    var order_info = '<div id=' + order_item_id + '><input name="venueConsList[' + index + '].reserveFieldId" value=\'' + fieldId + '\' type="hidden">'
                            + '<input name="venueConsList[' + index + '].reserveFieldName" value=\'' + fieldName + '\' type="hidden">'
                            + '<input name="venueConsList[' + index + '].orderPrice" value=\'' + price + '\' type="hidden">'
                            + '<input name="venueConsList[' + index + '].startTime" value=\'' + startTime + '\' type="hidden">'
                            + '<input name="venueConsList[' + index + '].endTime" value=\'' + endTime + '\' type="hidden"></div>';
                    $("#orderForm").append(order_info);
                }
            } else {//取消预定
                $(this).removeClass("unPayed");
                $(this).addClass("access");
                $("#" + tr_id).remove();
                $("#" + order_item_id).remove();
            }
        });
    });
    function filedSelectJson() {
        var index = $("#orderForm div").length;
        /*有一个div包含提交按钮*/
        if (index > 1) {
            var a = {};
            var reserveVenueCons = $("#orderForm").serializeArray();
            var numreg = /\[[0-9]*\]\./;
            var index = 0;
            var attnum = 5;
            var tmp = 0;
            $.each(reserveVenueCons, function (n, v) {
                var name = v.name;
                var names = name.split(numreg);
                if (names.length > 1) {//数组属性
                    if (!a[names[0]])//如果a[]没有属性names[0]
                        a[names[0]] = []; //新建
                    if (!a[names[0]][index]) //如果a[names[0]]没有属性index
                        a[names[0]][index] = {};//新建
                    a[names[0]][index][names[1]] = v.value;//设置value
                    tmp++;
                    if ((tmp) % attnum == 0) {
                        index++;
                    }
                } else {//普通属性
                    a[v.name] = v.value;
                }
            });
            var rtn = JSON.stringify(a);
            var checkResult=checkStatus(rtn);
            if(checkResult){
                orderSubmit(rtn);
            }else{
                alert("该时间段已被占用");
            }
        } else {
            alert("请选择时间");
        }
    }
    function checkStatus(reserveJson) {
        var checkResult=null;
        jQuery.postItems({
            url: ctx + '/app/reserve/checkStatus',
            data: {
                reserveJson: reserveJson,
            },
            success: function (result) {
                checkResult=result;
            }
        });
        return checkResult;
    }
    function orderSubmit(reserveJson) {
        jQuery.postItems({
            url: ctx + '/app/reserve/reservation',
            data: {
                reserveJson: reserveJson,
                token:'${token}'
            },
            success: function (result) {
                if (result.bool) {
                    alert("预约成功");
                    location.reload();
                } else {
                    alert("预约失败");
                }

            }
        });
    }
</script>
</body>
</html>
