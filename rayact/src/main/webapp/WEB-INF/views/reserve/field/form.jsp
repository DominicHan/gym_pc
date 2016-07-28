<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>教练管理</title>
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
                    <h3>教练管理</h3>
                </div>
                <div class="content">
                    <form:form id="inputForm" modelAttribute="reserveField" action="${ctx}/reserve/reserveField/save"
                               method="post"
                               class="form-horizontal">
                    <form:hidden path="id"/>
                    <input type="hidden" name="token" value="${token}"/>


                    <div class="tab-container">
                        <ul class="nav nav-tabs" id="myTab">
                            <li class="active"><a href="#home" data-toggle="tab">基本信息</a></li>
                        </ul>

                        <div class="tab-content">
                            <div class="tab-pane active" id="home">
                                <div class="form-horizontal group-border-dashed">
                                    <div class="form-group">
                                        <label for="name" class="col-sm-3 control-label">场地名称：</label>

                                        <div class="col-sm-6">
                                            <form:input path="name" htmlEscape="false" maxlength="30"
                                                        class="form-control"/>
                                        </div>
                                    </div>
                                   <%-- <div class="form-group">
                                        <label for="name" class="col-sm-3 control-label">登陆名：</label>

                                        <div class="col-sm-6">
                                            <form:input path="loginName" htmlEscape="false" maxlength="30"
                                                        class="form-control"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="password" class="col-sm-3 control-label">密码：</label>
                                        <div class="col-sm-6">
                                            <form:input path="password" htmlEscape="false" maxlength="30"
                                                        class="form-control"/>
                                        </div>
                                    </div>--%>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">所属场馆：</label>
                                        <div class="col-sm-6">
                                            <sys:select cssClass="input-medium" name="reserveVenue.id"
                                                        cssStyle="width:100%"
                                                        value="${reserveField.reserveVenue.id}"
                                                        items="${venues}" itemLabel="name" itemValue="id"
                                                        defaultLabel="----请选择-----"
                                                        defaultValue=""></sys:select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">是否启用：</label>
                                        <div class="col-sm-6">
                                            <form:radiobuttons path="available" items="${fns:getDictList('yes_no')}"
                                                               itemLabel="label"
                                                               itemValue="value"
                                                               htmlEscape="false" class="icheck"/>
                                        </div>
                                    </div>
                                    <%--<div class="form-group">
                                        <label class="col-sm-3 control-label">绑定用户：</label>
                                        <div class="col-sm-6">
                                            <sys:select cssClass="input-medium" name="reserveUser.id"
                                                        cssStyle="width:100%"
                                                        value="${reserveField.reserveUser.id}"
                                                        items="${userList}" itemLabel="name" itemValue="id"
                                                        defaultLabel="请选择"
                                                        defaultValue=""></sys:select>
                                        </div>
                                    </div>--%>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">所属项目：</label>
                                        <div class="col-sm-6">
                                            <sys:select cssClass="input-medium" name="reserveProject.id"
                                                        cssStyle="width:100%"
                                                        value="${reserveField.reserveProject.id}"
                                                        items="${projects}" itemLabel="name" itemValue="id"
                                                        defaultLabel="请选择"
                                                        defaultValue=""></sys:select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">出生日期：</label>
                                        <div class="col-sm-6">
                                            <input value="<fmt:formatDate  pattern="yyyy-MM-dd" value="${reserveField.birthday}"/>"
                                                   name="birthday" id="birthday" type="text"
                                                   maxlength="20"
                                                   class="input-medium form-control Wdate "
                                                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                                        </div>
                                    </div>
                                    <j:if test="${reserveField.reserveParentField==''}">
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">父场地</label>
                                            <div class="col-sm-6">
                                                    ${reserveField.reserveParentField.name}
                                            </div>
                                        </div>
                                    </j:if>
                                    <input type="hidden" name="isTimeInterval" value="0"/>
                                   <%-- <div class="form-group">
                                        <label class="col-sm-3 control-label">是否分时令</label>
                                        <div class="col-sm-6">
                                            <form:radiobuttons path="isTimeInterval"
                                                               items="${fns:getDictList('yes_no')}"
                                                               itemLabel="label"
                                                               itemValue="value"
                                                               htmlEscape="false" class="icheck required"/>
                                        </div>
                                    </div>--%>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">备注：</label>
                                        <div class="col-sm-6">
                                            <form:textarea path="remarks" htmlEscape="false" rows="4"
                                                           maxlength="255" class="form-control"/>
                                        </div>
                                    </div>


                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">教练图片：</label>
                                        <div class="col-sm-6">
                                            <mechanism:upload id="financeSchoolPic" fdKey="fieldPic"
                                                              name="attMains1" exts=""
                                                              btnText="添加"
                                                              modelId="${reserveField.id}"
                                                              showImg="true" resizeImg="true" resizeWidth="454"
                                                              resizeHeight="247"
                                                              imgWidth="120" imgHeight="80"
                                                              modelName="reserveField" multi="true"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
<script type="text/javascript" src="${ctxStatic}/modules/reserve/js/validate.js"></script>
</body>
</html>
