<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>会员订单列表</title>
    <meta name="referrer" content="always"/>
    <meta charset='utf-8'/>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="${ctxStatic}/cleanzone/js/bootstrap/dist/css/bootstrap.css" rel="stylesheet"/>
    <style type="text/css">
        body {
            min-width: 320px;
            max-width: 540px;
            font-family: -apple-system, Helvetica, sans-serif;
            line-height: 1.5;
            font-size: 14px;
            -webkit-text-size-adjust: none;
            background: #F5F5F5;
            overflow-x: hidden
        }

        a {
            color: #0b0b0b
        }

        ol, ul {
            list-style: none;
        }

        .my_order_wrap {
            overflow: hidden;
        }

        .my_order_inner {
            position: relative;
            min-height: 300px;
            -webkit-transition: -webkit-transform .25s ease;
            transition: -webkit-transform .25s ease;
        }

        .my_order {
            position: absolute;
            top: 0;
            width: 100%;
            min-height: 300px;
        }

        .order_head {
            position: relative;
            min-height: 40px;
            line-height: 40px;;
        }

        .order_head::after {
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
        }

        .wx_wrap {
            position: relative;
            min-height: 375px;
        }

        .order_box {
            margin-bottom: 10px;
            padding: 0 10px 10px;
            background: #fff;
            position: relative;
        }

        .order_box::after, .order_box::before {
            border-color: #ccc;
        }

        .order_box::before {
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
        }

        .order_item {
            position: relative;
            margin-top: 10px;
        }

        .my_nav::after, .order_box::after {
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
        }

        .my_nav, .my_nav.fixed ul {
            width: 100%;
            background: #efefef;
        }

        .my_nav ul {
            display: flex;
        }

        .my_nav {
            height: 46px;
            position: relative;
            margin-bottom: -1px;
        }

        ul, ol, li {
            margin: 0;
            padding: 0;
            vertical-align: baseline;
        }

        .my_nav li {
            display: block;
            flex: 1;
        }

        .my_nav li.cur a {
            border-bottom: 3px solid #e4393c;
            color: #e4393c;
        }

        .my_nav a {
            position: relative;
            display: block;
            height: 43px;
            line-height: 45px;
            text-align: center;
            color: #666;
            font-size: 16px;
        }
    </style>
</head>
<body>
<jsp:include page="appHead.jsp"></jsp:include>

<div class="wx_wrap">
    <div class="my_nav">
        <ul id="nav">
            <li no="1" class="<c:if test="${reserveType == null}">cur</c:if>"><a href="${ctx}/app/reserve/orderList">全部</a></li>
            <li no="1" class="<c:if test="${reserveType == 1}">cur</c:if>"><a href="${ctx}/app/reserve/orderList?reserveType=1">已预订</a></li>
            <li no="2" class="<c:if test="${reserveType == 4}">cur</c:if>"><a href="${ctx}/app/reserve/orderList?reserveType=4">已完成<span class="num"></span></a></li>
        </ul>
    </div>
    <div class="my_order_wrap">
        <div style="height: 2353px;" class="my_order_inner" id="cont">
            <div class="my_order">
                <c:forEach items="${orderList}" var="order">
                    <div class="order_box">
                        <div class="order_head">
                            <span>日期：${order.orderDate}</span>
                            <span>订单编号：${order.orderId}</span>
                            <span>健身房：${order.venueName}</span>
                        </div>
                        <c:forEach items="${order.itemList}" var="item">
                            <div class="order_item">
                                <span>${item.fieldName}</span>
                                <span>${item.startTime}-${item.endTime}</span>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>
</body>
</html>
