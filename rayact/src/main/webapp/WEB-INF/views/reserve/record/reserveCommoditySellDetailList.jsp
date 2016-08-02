<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>商品销售记录</title>
    <meta name="decorator" content="main"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="reserveCommoditySellDetail"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="header">
                    <h3>商品销售记录</h3>
                </div>
                <form:form id="searchForm" modelAttribute="reserveCommoditySellDetail"
                           action="${ctx}/reserve/reserveCommoditySellDetail/findSellDetailList" method="post">

                    <div class="row breadcrumb form-search col-lg-12 col-sm-12"
                         style="margin-left:0px; margin-right:0px;">
                        <div class="form-group col-lg-3 col-lg-2">
                            <label class="control-label" for="venue">健身房：</label>
                            <sys:select id="venue" cssClass="input-large" name="reserveCommodity.reserveVenue.id"
                                        value="${reserveCommoditySellDetail.reserveCommodity.reserveVenue.id}"
                                        items="${venueList}" itemLabel="name" itemValue="id"
                                        defaultLabel="全部"
                                        defaultValue=""></sys:select>
                        </div>
                        <div class="form-group col-lg-3 col-sm-3">
                            <label class="control-label col-lg-5" for="payType">支付方式：</label>
                            <div class="col-lg-7">
                                <select id="payType" name="reserveCommoditySell.payType" style="width: 100%">
                                    <option value="">全部</option>
                                    <option value="1"
                                            <j:if test="${1 eq search.reserveCommoditySell.payType}">selected="selected"</j:if>
                                    >预储值
                                    </option>
                                    <option value="2"
                                            <j:if test="${2 eq search.reserveCommoditySell.payType}">selected="selected"</j:if>
                                    >现金
                                    </option>
                                    <option value="3"
                                            <j:if test="${3 eq search.reserveCommoditySell.payType}">selected="selected"</j:if>
                                    >银行卡
                                    </option>
                                    <option value="4"
                                            <j:if test="${4 eq search.reserveCommoditySell.payType}">selected="selected"</j:if>
                                    >微信
                                    </option>
                                    <option value="5"
                                            <j:if test="${5 eq search.reserveCommoditySell.payType}">selected="selected"</j:if>
                                    >支付宝
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group col-lg-2 col-sm-2">

                            <form:input path="reserveCommodity.name" htmlEscape="false"
                                        maxlength="30"
                                        placeholder="请输入商品名称"
                                        class="form-control"/>
                        </div>
                        <div class="form-group col-lg-2 col-sm-2">
                            <div class="col-lg-6 col-sm-6">
                                <input value="<fmt:formatDate  pattern="yyyy-MM-dd" value="${search.startDate}"/>"
                                       name="startDate" id="startDate" type="text"
                                       maxlength="20"
                                       class="input-medium form-control Wdate "
                                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                            </div>
                            <div class="col-lg-6 col-sm-6">
                                <input value="<fmt:formatDate  pattern="yyyy-MM-dd" value="${search.endDate}"/>"
                                       name="endDate" id="endDate" type="text"
                                       maxlength="20"
                                       class="input-medium form-control Wdate "
                                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                            </div>
                        </div>

                        <div class="form-group col-lg-2 col-sm-2">
                            <input id="btnSubmit" class="btn btn-primary" type="submit"
                                   value="查询"/><input id="btnExport" class="btn btn-primary"
                                                      type="button" value="导出"/>
                        </div>
                    </div>

                    <sys:message content="${message}"/>
                    <div class="content">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                <tr>
                                    <th>健身房</th>
                                    <th>商品名称</th>
                                    <th>商品类型</th>
                                    <th>购买数量</th>
                                    <th>单价</th>
                                    <th>合计</th>
                                    <th>支付方式</th>
                                    <th>售卖人</th>
                                    <th>时间</th>
                                    <th>备注</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:set var="sum" value="0"></c:set>
                                <c:set var="num" value="0"></c:set>
                                <c:forEach items="${page.list}" var="reserveCommoditySellDetail">
                                    <tr>
                                        <td>${reserveCommoditySellDetail.reserveCommodity.reserveVenue.name}</td>
                                        <td>${reserveCommoditySellDetail.reserveCommodity.name}</td>
                                        <td>${reserveCommoditySellDetail.reserveCommodity.commodityType.name}</td>
                                        <td>${reserveCommoditySellDetail.num}</td>
                                        <c:set var="num" value="${num+reserveCommoditySellDetail.num}"></c:set>
                                        <td>${reserveCommoditySellDetail.price}</td>
                                        <td>${reserveCommoditySellDetail.detailSum}</td>
                                        <td>
                                                ${fns:getPayType(reserveCommoditySellDetail.reserveCommoditySell.payType)}
                                        </td>
                                        <c:set var="sum" value="${sum+reserveCommoditySellDetail.detailSum}"></c:set>
                                        <td>${reserveCommoditySellDetail.updateBy.name}</td>

                                        <td><fmt:formatDate value="${reserveCommoditySellDetail.createDate}"
                                                            type="both"/></td>
                                        <td>${reserveCommoditySellDetail.remarks}</td>
                                    </tr>
                                </c:forEach>
                                <td colspan="2"> 以上数据合计</td>
                                <td>${num}</td>
                                <td></td>
                                <td>${sum}</td>
                                <td colspan="5"></td>
                                </tbody>
                            </table>
                            <div class="row">
                                <div class="col-sm-12">

                                    <div class="pull-right">
                                        <div class="dataTables_paginate paging_bs_normal">
                                            <sys:javascript_page p="${page}" formId="searchForm"></sys:javascript_page>
                                        </div>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $("#btnExport").click(function () {
        $("#searchForm").attr("action", "${ctx}/reserve/reserveCommoditySellDetail/findSellDetailListExport");
        $("#searchForm").submit();
        $("#searchForm").attr("action", "${ctx}/reserve/reserveCommoditySellDetail/findSellDetailList");
    });
</script>
</body>
</html>
