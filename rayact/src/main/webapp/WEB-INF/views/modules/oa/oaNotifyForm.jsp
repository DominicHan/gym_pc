<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
	<title>通知管理</title>
	<meta name="decorator" content="main"/>
	<%@include file="/WEB-INF/views/include/upload.jsp" %>
</head>
<body>
<c:choose>
	<c:when test="${requestScope.oaNotify.self}">
		<c:set var="action" value="selfNotify"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="action" value="oaNotify"></c:set>
	</c:otherwise>
</c:choose>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
	<jsp:param name="action" value="${action}"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
	<div class="page-head">
		<h3>通知管理</h3>
	</div>
	<div class="cl-mcont">
		<div class="block-flat">
			<form:form id="inputForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/save"
					   class="form-horizontal" role="form">
				<form:hidden path="id"/>
				<input type="hidden" name="token" value="${token}"/>
				<sys:msg content="${message}"/>
				<div class="form-group">
					<label class="col-sm-2 control-label">类型：</label>
					<div class="col-sm-4">
						<sys:select cssClass="input-xlarge" name="type"
									cssStyle="width:100%"
									items="${notifyTypeList}"
									value="${oaNotify.type}"
									defaultLabel="请选择类型"
									defaultValue=""
									itemLabel="label"
									itemValue="value"
						></sys:select>

						<span class="help-inline"><font color="red">*</font> </span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">标题：</label>
					<div class="col-sm-4">
						<form:input path="title" htmlEscape="false" maxlength="200" cssStyle="width: 100%" class="input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">内容：</label>

					<div class="col-sm-4">
						<form:textarea path="content" htmlEscape="false" rows="6" cssStyle="width: 100%" maxlength="2000" class="input-xxlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</div>
				</div>
				<c:if test="${oaNotify.status ne '1'}">
					<div class="form-group">
						<label class="col-sm-2 control-label">附件：</label>
						<div class="col-sm-4">
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="255" class="input-xlarge"/>
							<sys:ckfinder input="files" type="files" uploadPath="/oa/notify" selectMultiple="true"/>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">状态：</label>
						<div class="col-sm-4">
							<form:radiobuttons path="status" cssClass="icheck" items="${fns:getDictList('oa_notify_status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
							<span class="help-inline"><font color="red">*</font> 发布后不能进行操作。</span>
						</div>
					</div>
				</c:if>
				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-10">
						<c:if test="${oaNotify.status ne '1'}">
							<button type="submit" id="btnSubmit" class="btn btn-primary">保存</button>
						</c:if>
						<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
					</div>
				</div>
			</form:form>
		</div>
	</div>
</div>
</body>
<script type="text/javascript">
	$(document).ready(function () {
		$('.icheck').iCheck({
			checkboxClass: 'icheckbox_square-blue checkbox',
			radioClass: 'iradio_square-blue'
		});
	});
</script>
</html>
