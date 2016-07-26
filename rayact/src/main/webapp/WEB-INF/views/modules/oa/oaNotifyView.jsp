<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
	<title>消息通知</title>
	<meta name="decorator" content="main"/>
	<%@include file="/WEB-INF/views/include/upload.jsp" %>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
	<jsp:param name="action" value="selfNotify"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
	<div class="page-head">
        <div class="row">
            <div class="col-lg-2">
                <h3>消息通知</h3>
            </div>
            <div class="col-lg-1 pull-right">
           <%--     <a href="${ctx}/oa/oaNotify/self"><img style="width:30px;height: 30px"
                                                                         src="${ctxStatic}/modules/reserve/images/return.png"></a>--%>
                <div class="form-group">
                    <input id="btnCancel" class="btn btn-primary" type="button" value="返 回" onclick="history.go(-1)"/>
                </div>
            </div>
        </div>
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
					<div class=" col-sm-4">
						<sys:select cssClass="input-xlarge" name="type"
									cssStyle="width:100%"
									items="${notifyTypeList}"
									value="${oaNotify.type}"
									defaultLabel="请选择类型"
									defaultValue=""
									itemLabel="label"
									itemValue="value"
						></sys:select>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">标题：</label>
					<div class="col-sm-4 form-control-static">
						${oaNotify.title}
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">内容：</label>
					<div class="col-sm-4 form-control-static">
						${oaNotify.content}
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
							<form:radiobuttons path="status" items="${fns:getDictList('oa_notify_status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
							<span class="help-inline"><font color="red">*</font> 发布后不能进行操作。</span>
						</div>
					</div>
				</c:if>

			</form:form>
		</div>
	</div>
</div>
</body>
</html>
