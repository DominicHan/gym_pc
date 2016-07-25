<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
	<meta name="decorator" content="main"/>
	<title>生日提醒列表</title>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
	<jsp:param name="action" value="birthdayNotify"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
	<div class="row">
		<div class="col-md-12">
			<div class="block-flat">
				<div class="header">
					<h3>生日提醒列表</h3>
				</div>
				<form:form id="searchForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/list"
						   method="post">
					<sys:message content="${message}"/>
					<div class="breadcrumb form-search">
						<div class="row">
							<div class="col-sm-10 col-md-10 col-lg-10">
								<table class="no-border">
									<tbody class="no-border-y">
									<ul class="ul-form">
										<td>标题：</td>
										<td><form:input path="title" htmlEscape="false" maxlength="30"
														class="form-control"/></td>

										<td><input id="btnSubmit" class="btn btn-primary" type="submit"
												   value="查询"/></td>

									</ul>
									</tbody>
								</table>
							</div>
							<div class="pull-right">
								<a class="btn btn-success" href="${ctx}/oa/oaNotify/form">
									<i class="fa fa-plus"></i>添加
								</a>
							</div>
						</div>
					</div>
					<div class="content">
						<div class="table-responsive">
							<table>
								<thead>
								<tr>
									<th>标题</th>
									<th>类型</th>
									<th>状态</th>
									<th>查阅状态</th>
									<th>更新时间</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${page.list}" var="oaNotify">
									<tr>
										<td>
											<a href="${ctx}/oa/oaNotify/form?id=${oaNotify.id}">
												${fns:abbr(oaNotify.title,50)}
											</a>
										</td>
										<td>
											${fns:getDictLabel(oaNotify.type, 'oa_notify_type', '')}
										</td>
										<td>
												${fns:getDictLabel(oaNotify.status, 'oa_notify_status', '')}
										</td>
										<td>
											<c:if test="${requestScope.oaNotify.self}">
												${fns:getDictLabel(oaNotify.readFlag, 'oa_notify_read', '')}
											</c:if>
											<c:if test="${!requestScope.oaNotify.self}">
												${oaNotify.readNum} / ${oaNotify.readNum + oaNotify.unReadNum}
											</c:if>
										</td>
										<td>
											<fmt:formatDate value="${oaNotify.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
										</td>
										<td>
											<a href="${ctx}/oa/oaNotify/form?id=${oaNotify.id}">修改</a>
											<a href="${ctx}/oa/oaNotify/delete?id=${oaNotify.id}" onclick="return confirmx('确认要删除该通知吗？', this.href)">删除</a>
										</td>
									</tr>
								</c:forEach>
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
</body>
</html>
