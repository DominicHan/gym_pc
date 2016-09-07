<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<head>
    <title>会员订单列表</title>
    <%-- <link type="text/css" rel="stylesheet" href="${ctxStatic}/app/css/order_list.css"/>--%>
    <style type="text/css">
        body {
            font-family: -apple-system, Helvetica, sans-serif;
            line-height: 1.5;
            font-size: 14px;
            text-align: center;
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

        .my_section {
            position: relative;
            margin: 15px 0;
            background: #fff;
        }

        .my_section::before {
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
        }

        .my_section .head {
            position: relative;
            display: block;
            height: 45px;
            line-height: 45px;
            font-size: 14px;
            padding: 0 10px;
        }

        .my_section .head span {
            color: #999;
            position: absolute;
            right: 25px;
            font-size: 12px;
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
            min-height: 60px;
        }
        .wx_wrap {
            position: relative;
            min-height: 375px;
        }

        .order, .order_box {
            margin-bottom: 10px;
            padding: 0 10px 10px;
            background: #fff;
            position: relative;
        }

        .order::after, .order::before, .order_box::after, .order_box::before {
            border-color: #ccc;
        }

        .order::before, .order_box::before {
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
        }

        .order_shopBar {
            line-height: 40px;
            font-size: 14px;
        }

        .order_shopBar::before {
            content: '\20';
            width: 30px;
            height: 30px;
            background-size: 30px 60px;
        }

        .order_shopBar::after {
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
        }

        .order_item {
            position: relative;
            margin-top: 10px;
        }
        .order_shopBar::before, .order_shopBar em {
            display: inline-block;
            vertical-align: middle;
            margin-top: -2px;
        }
        .order_shopBar::before {
            content: '\20';
            width: 30px;
            height: 30px;
            background: url(//wq.360buyimg.com/fd/base/img/order/order_shopBar.png) no-repeat 0 0;
            background-size: 30px 60px;
        }
        .order_shopBar::after {
            border-color: #eee;
        }
        .order_shopBar {
            line-height: 40px;
            font-size: 14px;
        }
        .order_shopBar::after{
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
        }
    </style>
</head>
<body>
<jsp:include page="appHead.jsp"></jsp:include>
<section class="my_section" id="myActivity">
    <div class="head head_act">订单列表</div>
    <ul class="list list_act">

    </ul>
</section>
<div class="wx_wrap">
    <div class="my_order_wrap">
        <div style="height: 2353px;" class="my_order_inner" id="cont">
            <div class="my_order">
                <div class="order_box">
                    <div class="order_head">
                        order_head
                    </div>
                    <div class="order_shopBar">京东</div>
                    <div class="order_item">
                        <span >亚光 毛巾家纺 缎档弱捻脉动面巾两条装 吸水柔软 米/棕 90g/条 34x72cm/条</span>
                    </div>
                </div>
                <div class="order_box">
                    <div class="order_head">
                        order_head
                    </div>
                    <div class="order_shopBar">京东</div>
                    <div class="order_item">
                        <span>亚光 毛巾家纺 缎档弱捻脉动面巾两条装 吸水柔软 米/棕 90g/条 34x72cm/条</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%--<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="content">
                    <div class="table-responsive">

                        <c:forEach items="${orderList}" var="order">
                            订单编号：${order.orderId}
                            <table>
                                <thead>
                                <tr>
                                    <th>教练</th>
                                    <th>开始时间</th>
                                    <th>结束时间</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${order.itemList}" var="item">
                                    <tr>
                                        <td>
                                                ${item.fieldName}
                                        </td>
                                        <td>
                                                ${item.startTime}
                                        </td>
                                        <td>
                                                ${item.endTime}
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:forEach>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>--%>
</body>
</html>
