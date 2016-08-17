<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>预储值管理</title>
    <meta name="decorator" content="main"/>
    <%@include file="/WEB-INF/views/include/upload.jsp" %>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="storedCardMember"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="header">
                    <h3>预储值管理</h3>
                </div>
                <div class="content">
                    <td class="tab-container">
                        <tr class="form-horizontal group-border-dashed">
                            <form:form id="inputForm" modelAttribute="reserveMember"
                                       action="${ctx}/reserve/storedCardMember/save" method="post"
                                       class="form-horizontal" onsubmit="return checkForm()">
                                <form:hidden id="id" path="id"/>
                            <input type="hidden" name="token" value="${token}"/>
                                <sys:message content="${message}"/>
                            <table id="contentTable" class="table table-bordered">
                                <tr>
                                    <td>卡号:</td>
                                    <td>
                                        <form:input id="cardNo" path="cardno" htmlEscape="false" maxlength="20"
                                                    placeholder="卡号请勿包含-"
                                                    class="form-control required"/>
                                        <span class="help-inline"><font color="red">*</font> </span>
                                    </td>
                                    <td>姓名:</td>
                                    <td><form:input path="name" htmlEscape="false" maxlength="30"
                                                    class="required form-control"/>
                                        <span class="help-inline"><font color="red">*</font> </span></td>
                                </tr>
                                <tr>
                                    <td>身份证:</td>
                                    <td>
                                        <form:input id="sfz" path="sfz" htmlEscape="false" maxlength="18"
                                                    class="form-control "/>
                                    </td>

                                    <td>地址:</td>
                                    <td>
                                        <form:input path="address" htmlEscape="false" maxlength="100"
                                                    class="form-control "/>
                                    </td>
                                </tr>

                                <tr>
                                    <td>性别:</td>
                                    <td>
                                        <form:radiobuttons path="sex" items="${fns:getDictList('sex')}"
                                                           itemLabel="label" itemValue="value"
                                                           htmlEscape="false"/>
                                    </td>
                                    <td>手机号:</td>

                                    <td>
                                        <form:input id="mobile" path="mobile" htmlEscape="false" maxlength="20"
                                                    class="form-control phone required"/>
                                        <span class="help-inline"><font color="red">*</font> </span>
                                    </td>

                                </tr>
                                <tr>
                                    <td>余额:</td>
                                    <td>
                                        <input type="text"
                                               value="<fmt:formatNumber value="${reserveMember.remainder}" groupingUsed="false" />"
                                               name="remainder"
                                               class="form-control " maxlength="20"
                                               <j:if test="${!fns:isAdmin()}">readonly="readonly"</j:if>/>
                                    </td>

                                    <td>储值卡名称:</td>
                                    <td>
                                        <sys:select cssClass="input-medium" name="storedcardSet.id"
                                                    cssStyle="width:50%"
                                                    defaultLabel="请选择"
                                                    defaultValue=""
                                                    items="${storedcardSetList}"
                                                    value="${reserveMember.storedcardSet.id}"
                                                    itemLabel="name"
                                                    itemValue="id"></sys:select>
                                    </td>
                                </tr>
                                <tr>

                                </tr>
                                <tr>
                                    <td>健身房：</td>
                                    <td colspan="3">
                                        <sys:select cssClass="input-xlarge" name="reserveVenue.id" id="reserveVenue_id"
                                                    cssStyle="width:100%"
                                                    items="${venueList}"
                                                    value="${reserveMember.reserveVenue.id}"
                                                    defaultLabel="请选择开户健身房"
                                                    defaultValue=""
                                                    itemLabel="name"
                                                    itemValue="id"
                                        ></sys:select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>备注:</td>
                                    <td colspan="3">
                                        <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
                                                       class="form-control"/>
                                    </td>
                                </tr>
                            </table>
                            <div class="form-group">
                                <label class="col-sm-1 control-label">会员图片：</label>
                                <div class="col-sm-6">
                                    <mechanism:upload id="financeSchoolPic" fdKey="memberPic"
                                                      name="attMains1" exts=""
                                                      btnText="添加"
                                                      modelId="${reserveMember.id}"
                                                      showImg="true" resizeImg="true" resizeWidth="454"
                                                      resizeHeight="247"
                                                      imgWidth="120" imgHeight="80"
                                                      modelName="com.bra.modules.reserve.entity.ReserveMember" multi="true"/>
                                </div>
                            </div>
                            <div>
                                <input id="btnSubmit"
                                       class="btn btn-primary"
                                       type="submit" required
                                       value="保 存"/>&nbsp;
                                <input id="btnCancel" class="btn" type="button" value="返 回"
                                       onclick="history.go(-1)"/>
                            </div>
                            </form:form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${ctxStatic}/modules/reserve/js/reserve_member_form.js" type="text/javascript"></script>
</body>
</html>