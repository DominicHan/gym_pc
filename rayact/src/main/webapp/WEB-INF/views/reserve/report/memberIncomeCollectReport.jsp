<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <meta name="decorator" content="main"/>
    <link type="text/css" rel="stylesheet" href="${ctxStatic}/modules/reserve/css/field.css?id=7862256"/>
    <title>会员充值统计</title>
</head>
<body>
<c:if test="${param.alone != 'true'}">
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="memberIncomeReport"></jsp:param>
</jsp:include>
</c:if>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="header">
                    <h3>会员充值统计</h3>
                </div>
                <form:form id="searchForm" modelAttribute="reserveCardStatements"
                           action="${ctx}/reserve/reserveCardStatements/memberIncomeReport?alone=${alone}"
                           method="post" class="breadcrumb form-search">
                    <div class="row">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <table class="no-border">
                                <tbody class="no-border-y">
                                <td>健身房：</td>
                                <td>

                                    <sys:select cssClass="input-xlarge" name="reserveVenue.id"
                                                cssStyle="width:80%"
                                                value="${reserveMemberIntervalReport.reserveVenue.id}"
                                                items="${reserveVenueList}" itemLabel="name" itemValue="id"
                                                defaultLabel="----请选择-----"
                                                defaultValue=""></sys:select>
                                </td>

                                <td>
                                    <div class="btn-group" id="payType">
                                        <label class="radio-inline">
                                            <input type="radio" class="icheck" value="1" checked="checked"
                                                   name="queryType"/>汇总
                                        </label>

                                        <label class="radio-inline">
                                            <input type="radio" class="icheck" value="2" name="queryType"/>明细
                                        </label>
                                    </div>
                                </td>
                                <td>
                                    <input value="<fmt:formatDate  pattern="yyyy-MM-dd" value="${reserveMemberIntervalReport.startDate}"/>"
                                           name="startDate" id="startDate" type="text"
                                           maxlength="20"
                                           class="input-medium form-control Wdate "
                                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                                </td>
                                <td>
                                    <input value="<fmt:formatDate  pattern="yyyy-MM-dd" value="${reserveMemberIntervalReport.endDate}"/>"
                                           name="endDate" id="endDate" type="text"
                                           maxlength="20"
                                           class="input-medium form-control Wdate "
                                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                                </td>
                                <td><input id="btnSubmit" class="btn btn-primary" type="submit"
                                           value="查询"/></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </form:form>
                <sys:msg content="${message}"/>
                <div class="content">
                    <div class="table-responsive">
                        <table>
                            <thead>
                            <tr>
                                <th>场馆</th>
                                <th>预储值</th>
                                <th>现金</th>
                                <th>银行卡</th>
                                <th>微信</th>
                                <th>（个人）微信</th>
                                <th>支付宝</th>
                                <th>（个人）支付宝</th>
                                <th>欠账</th>
                                <th>优惠券</th>
                                <th>合计</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${collectReport}" var="report">
                                <tr>
                                    <td>
                                            ${report.reserveVenue.name}
                                    </td>

                                    <td>
                                            ${report.storedCardBill}
                                    </td>

                                    <td>
                                            ${report.cashBill}
                                    </td>

                                    <td>
                                            ${report.bankCardBill}
                                    </td>

                                    <td>
                                            ${report.weiXinBill}
                                    </td>

                                    <td>
                                            ${report.personalWeiXinBill}
                                    </td>

                                    <td>
                                            ${report.aliPayBill}
                                    </td>

                                    <td>
                                            ${report.personalAliPayBill}
                                    </td>

                                    <td>
                                            ${report.dueBill}
                                    </td>

                                    <td>
                                            ${report.otherBill}
                                    </td>
                                    <td>
                                            ${report.bill}
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${ctxStatic}/modules/reserve/js/commodity_income_record.js" type="text/javascript"></script>
</body>
</html>
