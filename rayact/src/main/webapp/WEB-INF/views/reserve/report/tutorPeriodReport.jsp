<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>教练课时量统计</title>
    <meta name="decorator" content="main"/>
    <link type="text/css" rel="stylesheet" href="${ctxStatic}/modules/reserve/css/field.css?id=7862256"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="tutorPeriodReport"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="header">
                    <h3>教练课时量统计</h3>
                </div>
                <form id="searchForm" action="${ctx}/reserve/saleVenue/tutorPeriodReport"
                      method="post">
                    <div class="row breadcrumb form-search col-lg-12 col-sm-12"
                         style="margin-left:0px; margin-right:0px;">
                        <div class="form-group col-lg-2 col-sm-2">
                            <label class="control-label" for="venue">健身房：</label>
                            <select id="venue" name="venue.id" class="select2 ">
                                <option value="">请选择</option>
                                <c:forEach items="${venueList}" var="venue">
                                    <option
                                            <j:if test="${venue.id eq query.venue.id}">selected="selected"</j:if>
                                            value="${venue.id}">${venue.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group col-lg-2 col-sm-2">
                            <label class="control-label" for="field">教练：</label>
                            <select  id="field" name="field.id" class="select2 ">
                                <option value="">请选择</option>
                                <c:forEach items="${fieldList}" var="field">
                                    <option
                                            <j:if test="${field.id eq query.field.id}">selected="selected"</j:if>
                                            value="${field.id}">${field.name}</option>
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
                                    <th>健身房</th>
                                    <th>教练</th>
                                    <th>课时量</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${page.list}" var="log">
                                    <tr>
                                        <td>${log.venue.name}</td>
                                        <td>${log.field.name}</td>
                                        <td>${log.periodNum}</td>
                                        <td>
                                            <a class="btn btn-primary btn-xs"
                                               href="${ctx}/reserve/saleVenue/tutorPeriodDetail?field.id=${log.field.id}&startDate=<fmt:formatDate value="${query.startDate}" pattern="yyyy-MM-dd"/>&endDate=<fmt:formatDate value="${query.endDate}" pattern="yyyy-MM-dd"/>"><i
                                                    class="fa fa-pencil"></i>详情</a>
                                        </td>
                                    </tr>
                                </c:forEach>
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
