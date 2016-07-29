<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>无教练课时设置</title>
    <meta name="decorator" content="main"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="venueVisitorsSet"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="header">
                    <h3>无教练课时设置</h3>
                </div>
                <form:form id="searchForm" modelAttribute="reserveVenueVisitorsSet"
                           action="${ctx}/reserve/reserveVenueVisitorsSet/list"
                           method="post" class="breadcrumb form-search">
                    <div class="row">
                        <div class="col-sm-6 col-md-6 col-lg-6">
                            <table class="no-border">
                                <tbody class="no-border-y">
                                <tr>
                                    <td>课时名称：</td>
                                    <td>
                                        <form:input path="name" htmlEscape="false" cssstyle="width:70px;" maxlength="30"
                                                    class="form-control"/>
                                    </td>
                                    <td><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>


                        <div class="pull-right">
                            <a id="addBtn" class="btn btn-success" >
                                <i class="fa fa-plus"></i>添加
                            </a>
                        </div>
                    </div>
                </form:form>
                <div class="content">
                    <div class="table-responsive">
                        <table>
                            <thead>
                            <tr>
                                <th>课时名称</th>
                                <th>项目</th>
                                <th>健身房</th>
                                <th>是否启用</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${page}" var="bean">
                                <tr>
                                    <td>
                                        ${bean.name}
                                    </td>
                                    <td>${bean.project.name}</td>
                                    <td>${bean.reserveVenue.name}</td>
                                    <td>
                                            ${fns:getDictLabel(bean.available, 'yes_no', '')}
                                    </td>
                                    <td>
                                        <a class="btn btn-primary btn-xs editBtn" data-id="${bean.id}"><i
                                                class="fa fa-pencil"></i>修改</a>
                                        <a class="btn btn-danger btn-xs"
                                           href="${ctx}/reserve/reserveVenueVisitorsSet/delete?id=${bean.id}"
                                           onclick="return confirmb('确认要删除票次吗？', this.href)"><i
                                                class="fa fa-times"></i>删除</a>
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
<jsp:include page="../include/periodSetModal.jsp"></jsp:include>
<script type="text/javascript" src="${ctxStatic}/modules/reserve/js/visitor_set_form.js"></script>
<script type="text/javascript" src="${ctxStatic}/modules/reserve/js/visitor_set_save.js"></script>
</body>
</html>