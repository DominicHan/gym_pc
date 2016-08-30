<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>教练预约</title>
    <link href="${ctxStatic}/cleanzone/js/bootstrap/dist/css/bootstrap.css" rel="stylesheet"/>
</head>
<body>
微信公共平台
<a href="${ctx}/logout">退出</a>
<table>
    <c:forEach items="${list}" var="reserveField">
        <tr>
            <td>
                <a class="btn btn-primary btn-lg" href="${ctx}/reserve/reserveField/form?id=${reserveField.id}">${reserveField.name}</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>