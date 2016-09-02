<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>教练预约</title>
    <meta name="referrer" content="always"/>
    <meta charset='utf-8'/>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <meta name="format-detection" content="telephone=no"/>
    <link href="${ctxStatic}/cleanzone/js/bootstrap/dist/css/bootstrap.css" rel="stylesheet"/>
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

        .my_section .list {
            position: relative;
            padding: 0;
        }

        .my_section .list li {
            position: relative;
            text-align: center;
        }

        .list_act {
            overflow: hidden;
        }

        .list_act li {
            float: left;
            width: 25%;
        }

        .my_section .list li a {
            position: relative;
            display: block;
            padding: 10px 0;
            color: #666;
        }

        .list_act a {
            font-size: 12px !important;
        }

        .my_section .list::before {
            border-color: #ddd;
        }

        .my_section::after, .list_act li::before {
            content: '';
            height: 0;
            display: block;
            border-bottom: 1px solid #ddd;
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
        }

        #myActivity *::after {
            border-top: 0px;
            border-left: 0px;
        }

        .my_section a.head::after {
            content: '\20';
            border-color: #999;
            width: 8px;
            height: 8px;
            right: 10px;
            margin-top: -5px;
        }

        .list_act li::before {
            border-color: #ddd;
        }

        #myActivity *::after {
            border-top: 0px;
            border-left: 0px;
        }

        .list_act li::after {
            border-color: #ddd;
            content: '';
            width: 0;
            display: block;
            border-right: 1px solid #ddd;
            position: absolute;
            top: 0;
            bottom: 0;
            right: 0;
        }
    </style>
</head>
<body>
<div style="background-color:#fff;padding:10px;border-bottom:1px solid rgb(178,178,178)">
    <table border="0" width="100%">
        <tbody>
        <tr>
            <td onclick="javascript:history.back(-1)" width="30px"><img
                    src="${ctxStatic}/images/weiXin_return.png"
                    style="margin-bottom:-2px;" height="22px"></td>
            <td width="30px">&nbsp;</td>
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
<section class="my_section" id="myActivity">
    <a href="javascript:void(0);" class="head head_act" data-tag="activity">教练列表<span id="navigat"></span></a>
    <ul class="list list_act">
        <c:forEach items="${list}" var="reserveField">
            <li><a href="${ctx}/app/reserve/field?filedId=${reserveField.id}"> ${reserveField.name}</a></li>
        </c:forEach>
    </ul>
</section>
</body>
</html>