<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>教练价格管理</title>
    <meta name="decorator" content="main"/>
    <%@include file="/WEB-INF/views/include/upload.jsp" %>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="field"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12" style="padding-right: 0px">
            <div class="block-flat">
                <div class="header">
                    <h3>场地管理</h3>
                </div>
                <div class="content">
                    <form:form id="inputForm" modelAttribute="reserveField"
                               action="${ctx}/reserve/reserveField/savePrice"
                               method="post"
                               class="form-horizontal">
                        <form:hidden path="id"/>
                        <input type="hidden" name="token" value="${token}"/>


                        <div class="tab-container">
                            <ul class="nav nav-tabs" id="myTab">
                                <li class="active"><a href="#profile">常规价格设定</a></li>
                            </ul>
                            <div class="tab-content">
                                <!--常规价格设置-->
                                <div class="tab-pane active" id="profile">
                                    <h5>${reserveField.reserveVenue.name} / ${reserveField.name}</h5>
                                    <table class="table table-bordered">
                                        <tr>
                                            <td><span id="weekTd" style="color: red">周一至周日</span></td>


                                            <%--<td>时间段:</td>
                                            <td>
                                                <select id="startTime">
                                                    <c:forEach items="${times}" var="t">
                                                        <option value="${t}">${t}</option>
                                                    </c:forEach>
                                                </select>
                                                至
                                                <select id="endTime">
                                                    <c:forEach items="${times}" var="t">
                                                        <option value="${t}">${t}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>--%>
                                            <td>市场价:</td>
                                            <td>
                                                <input type="text" id="marketPrice" class="number form-control"
                                                       style="width: 40px;height:30px;padding: 0px"/>
                                            </td>
                                            <td>会员价:</td>
                                            <td>
                                                <input type="text" id="memberPrice" class="number form-control"
                                                       style="width: 40px;height:30px;padding: 0px"/>
                                            </td>
                                            <td valign="top"><input id="globalPrice" data="all" class="btn btn-primary"
                                                                    type="button"
                                                                    value="价格设定"/></td>
                                        </tr>
                                    </table>
                                    <table class="table table-bordered" style="padding:1px">
                                        <tr>
                                            <td colspan="2">时间</td>
                                            <c:forEach items="${times}" var="t">
                                                <th><span style="font-size: 10px">${t}</span></th>
                                            </c:forEach>
                                        </tr>
                                            <%-- 这层遍历主要是为了获得某个周次的价格--%>
                                        <c:forEach items="${priceSetList}" var="priceSet" varStatus="status">
                                            <tr>
                                                    <%--第0-1行：周一到周五 第2-3行：周六 第4-5行：周日--%>
                                                <j:if test="${status.index==0||status.index==2||status.index==4}">
                                                    <td rowspan="2" valign="top">
                                                        <a data="${priceSet.week}"
                                                           style="color: red"
                                                           style="width: 25px;"
                                                           title="点击,设计全局数值" href="#"
                                                           class="weekPriceTable">${priceSet.weekName}</a>
                                                    </td>
                                                </j:if>
                                                    <%--第0-1行：周一到周五 第2-3行：周六 第4-5行：周日--%>
                                                <td valign="top">${priceSet.consTypeName}</td>
                                                    <%--顾客标准--%>
                                                <input type="hidden" name="fieldPriceSetList[${status.index}].id"
                                                       value="${priceSet.id}"/><%--价格设置的id--%>
                                                <input type="hidden" name="fieldPriceSetList[${status.index}].week"
                                                       value="${priceSet.week}"/><%--周次--%>
                                                <input type="hidden"
                                                       name="fieldPriceSetList[${status.index}].consType"
                                                       value="${priceSet.consType}"/>
                                                    <%-- 这层遍历主要是为了获得时间的index 从而遍历出每个时间的价格--%>
                                                    <c:forEach items="${priceSet.timePriceList}" var="t"
                                                               varStatus="priceSetStatus">

                                                            <td style="padding:5px">
                                                                <input type="hidden"
                                                                       name="fieldPriceSetList[${status.index}].timePriceList[${priceSetStatus.index}].time"
                                                                       value="${t.time}"/>
                                                                <input value="<fmt:formatNumber value='${t.price}' pattern='0.00'/>"
                                                                       type="text" data-time="${t.time}"
                                                                       data="${priceSet.week}-${priceSet.consType}"
                                                                       name="fieldPriceSetList[${status.index}].timePriceList[${priceSetStatus.index}].price"
                                                                       class="number form-control"/>
                                                            </td>
                                                </c:forEach>
                                                    <%-- 这层遍历主要是为了获得时间的index 从而遍历出每个时间的价格--%>
                                            </tr>
                                        </c:forEach>
                                            <%-- 这层遍历主要是为了获得某个周次的价格--%>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="form-actions">
                            <input id="btnSubmit"
                                   class="btn btn-primary"
                                   type="submit"
                                   value="保 存"/>&nbsp;
                            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="${ctxStatic}/modules/reserve/js/price_set_form.js"></script>
</body>
</html>
