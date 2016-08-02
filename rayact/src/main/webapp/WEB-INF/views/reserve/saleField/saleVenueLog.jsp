<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>场地售卖报表</title>
    <meta name="decorator" content="main"/>
    <link type="text/css" rel="stylesheet" href="${ctxStatic}/modules/reserve/css/field.css?id=7862256"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="saleVenueLog"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="header">
                    <h3>会员健身记录</h3>
                </div>
                <form id="searchForm" action="${ctx}/reserve/saleVenue/list"
                      method="post">
                    <div class="row breadcrumb form-search col-lg-12 col-sm-12"
                         style="margin-left:0px; margin-right:0px;">
                        <div class="form-group col-lg-2 col-sm-2">
                            <label class="control-label" for="venue">健身房：</label>
                            <select id="venue" name="venue.id" class="select2 ">
                                <option value="">---请选择---</option>
                                <c:forEach items="${venueList}" var="venue">
                                    <option
                                            <j:if test="${venue.id eq query.venue.id}">selected="selected"</j:if>
                                            value="${venue.id}">${venue.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group col-lg-1 col-sm-1">
                            <input name="username" htmlEscape="false" style="width: 100%"
                                   maxlength="30" value="${query.username}"
                                   placeholder="请输入预订人"
                                   class="form-control"/>
                        </div>
                        <div class="form-group col-lg-2 col-sm-2">
                            <label class="control-label" for="payType">支付方式：</label>
                            <select id="payType" name="payType" style="width:50%">
                                <option value="">全部</option>
                                <option value="1" <j:if test="${1 eq query.payType}">selected="selected"</j:if> >储值卡</option>
                                <option value="11" <j:if test="${11 eq query.payType}">selected="selected"</j:if> >预储教练课时</option>
                            </select>
                        </div>

                        <div class="form-group col-lg-2 col-sm-2">
                            <label class="control-label" for="createBy">预订操作人：</label>
                            <select id="createBy" name="createBy.id" class="select2">
                                <option value="">请选择</option>
                                <c:forEach items="${userList}" var="createBy">
                                    <option
                                            <j:if test="${createBy.id eq query.createBy.id}">selected="selected"</j:if>
                                            value="${createBy.id}">${createBy.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group col-lg-2 col-sm-2">
                            <div class="col-lg-6 col-sm-6">
                                <input name="startDate"
                                       value="<fmt:formatDate value="${query.startDate}" pattern="yyyy-MM-dd"/>"
                                       type="text" id="startDate"
                                       maxlength="20"
                                       class="input-medium form-control Wdate "
                                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"
                                />
                            </div>
                            <div class="col-lg-6 col-sm-6">
                                <input name="endDate"
                                       value="<fmt:formatDate value="${query.endDate}" pattern="yyyy-MM-dd"/>"
                                       type="text" id="endDate"
                                       maxlength="20"
                                       class="input-medium form-control Wdate "
                                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"
                                />
                            </div>
                        </div>
                        <div class="form-group col-lg-2 col-sm-3">
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
                            <input id="btnExport" class="btn btn-primary" type="button" value="导出"/>
                        </div>
                    </div>
                    <div class="content">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                <tr>
                                    <%--  <th>订单编号</th>--%>
                                    <th>会员</th>
                                    <th>健身房</th>
                                    <th>项目</th>
                                    <th>时间区间</th>
                                    <th>教练费</th>
                                    <th>应收</th>
                                    <th>优惠</th>
                                    <th>实收</th>
                                    <th>支付方式</th>
                                    <th>预订人</th>
                                    <th>结账人</th>
                                    <th>授权人</th>
                                    <th>订单时间</th>
                                    <th>操作时间</th>
                                    <j:if test="${userType==1 || userType==5}">
                                        <th>操作</th>
                                    </j:if>
                                </tr>
                                </thead>
                                <tbody>
                                <c:set var="orderPriceSum" value="0"></c:set>
                                <c:set var="shouldPriceSum" value="0"></c:set>
                                <c:set var="discountPriceSum" value="0"></c:set>
                                <c:set var="consPriceSum" value="0"></c:set>
                                <c:forEach items="${page.list}" var="log">
                                    <tr style="height: 30px;">
                                            <%-- <td>${log.id}</td>--%>
                                        <td>${log.member.name}</td>
                                        <td>${log.venue.name}</td>
                                        <td>${log.project.name}</td>
                                        <td>${log.startTime}—${log.endTime}</td>
                                        <td>${log.orderPrice}</td>
                                        <c:set var="orderPriceSum" value="${orderPriceSum+log.orderPrice}"></c:set>
                                        <td>${log.shouldPrice}</td>
                                        <c:set var="shouldPriceSum" value="${shouldPriceSum+log.shouldPrice}"></c:set>
                                        <td>${log.discountPrice}</td>
                                        <c:set var="discountPriceSum"
                                               value="${discountPriceSum+log.discountPrice}"></c:set>
                                        <td>${log.consPrice}</td>
                                        <c:set var="consPriceSum" value="${consPriceSum+log.consPrice}"></c:set>
                                        <td>${fns:getPayType(log.payType)}</td>
                                        <td>${log.createBy.name}</td>
                                        <td>${log.updateBy.name}</td>
                                        <td>${log.checkoutName}</td>
                                        <td><fmt:formatDate value="${log.consDate}"
                                                            type="date"></fmt:formatDate></td>
                                        <td><fmt:formatDate value="${log.updateDate}"
                                                            type="both"></fmt:formatDate></td>
                                        <j:if test="${userType==1 || userType==5}">
                                            <td>
                                                <a class="btn btn-danger btn-xs"
                                                   href="${ctx}/reserve/saleVenue/delete?orderId=${log.id}&isTicket=${log.isTicket}"
                                                   onclick="return confirmb('预订人：${log.member.name}<br>时间区间：${log.startTime}—${log.endTime}<br>实收金额：${log.consPrice}<br><br>确认要删除该记录吗？', this.href)">
                                                    <i class="fa fa-times"></i>删除</a>
                                            </td>
                                        </j:if>
                                    </tr>
                                </c:forEach>
                                <tr style="height: 30px;">
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td>${orderPriceSum}</td>
                                    <td>${shouldPriceSum}</td>
                                    <td>${discountPriceSum}</td>
                                    <td>${consPriceSum}</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
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
                </form>
            </div>

        </div>
    </div>
</div>
<%@include file="../include/modal.jsp" %>
<script type="text/javascript">
    $("#btnExport").click(function () {
        $("#searchForm").attr("action", "${ctx}/reserve/saleVenue/listExport");
        $("#searchForm").submit();
        $("#searchForm").attr("action", "${ctx}/reserve/saleVenue/list");
    });
</script>
<script type="text/javascript" src="${ctxStatic}/modules/reserve/js/multiple_payments.js?t=" + Math.random()></script>
</body>
</html>
