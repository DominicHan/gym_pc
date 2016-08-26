<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>微信公共平台</title>
</head>
<body>
微信公共平台
<a href="${ctx}/logout">退出</a>
<table>
    <c:forEach items="${page.list}" var="reserveField">
        <tr>
            <td>
                <a href="${ctx}/reserve/reserveField/form?id=${reserveField.id}">${reserveField.name}</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>