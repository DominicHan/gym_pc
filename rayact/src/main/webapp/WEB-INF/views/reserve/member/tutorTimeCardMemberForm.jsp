<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>会员添加</title>
    <meta name="decorator" content="main"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/sidebar.jsp">
    <jsp:param name="action" value="tutorTimeCardMember"></jsp:param>
</jsp:include>
<div class="container-fluid" id="pcont">
    <div class="row">
        <div class="col-md-12">
            <div class="block-flat">
                <div class="header">
                    <h3>会员添加</h3>
                </div>
                <div class="content">
                    <div class="tab-container">
                        <div class="form-horizontal group-border-dashed">
                            <form:form id="inputForm" modelAttribute="reserveMember"
                                       action="${ctx}/reserve/tutorTimeCardMember/save" method="post"
                                       onsubmit="return checkForm()" class="form-horizontal">
                                <form:hidden id="id" path="id"/>
                                <input type="hidden" name="token" value="${token}"/>
                                <sys:message content="${message}"/>
                                <table id="contentTable" class="table table-bordered">
                                    <tr>
                                        <td>卡号:</td>
                                        <td>
                                            <form:input id="cardNo" path="cartno" htmlEscape="false" maxlength="20"
                                                        class="form-control required"/>
                                            <span class="help-inline"><font color="red">*</font> </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>姓名:</td>
                                        <td>
                                            <div class="input-group">
                                                <form:input path="name" htmlEscape="false" maxlength="30"
                                                            class="form-control required "/>
                                                <span class="input-group-addon"><font color="red">*</font> </span>
                                            </div>
                                        </td>
                                        <td>课时卡标准:</td>
                                        <td>
                                            <div class="input-group">
                                                <sys:select cssClass="input-xlarge" name="timecardSet.id"
                                                            id="timeCardSetId"
                                                            items="${timecardSetList}"
                                                            value="${reserveMember.timecardSet.id}"
                                                            itemLabel="name" itemValue="id"
                                                            cssStyle="width:100%"
                                                            defaultLabel="请选择课时卡"
                                                            defaultValue="">
                                                </sys:select>
                                                <span class="input-group-addon"><font color="red">*</font> </span>
                                            </div>
                                        </td>
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
                                            <form:radiobuttons path="sex" items="${fns:getDictList('sex')}" cssClass="icheck"
                                                               itemLabel="label" itemValue="value"
                                                               htmlEscape="false"/>
                                        </td>
                                        <td>手机号:</td>
                                        <td>
                                            <div class="input-group">
                                                <form:input id="mobile" path="mobile" htmlEscape="false" maxlength="20"
                                                            class="form-control phone required"/>
                                                <span class="input-group-addon"><font color="red">*</font> </span>
                                            </div>
                                        </td>

                                    </tr>

                                    <tr>


                                        <td>剩余次数:</td>
                                        <td>
                                            <div class="input-group">
                                                <form:input path="residue" htmlEscape="false" maxlength="11"
                                                            readonly="true"
                                                            class="form-control"/>
                                                <span class="input-group-addon">次</span>
                                            </div>
                                        </td>
                                        <td>余额:</td>
                                        <td>
                                            <div class="input-group" cssStyle="width: 30%">
                                                <form:input path="remainder" htmlEscape="false" readonly="true"
                                                            class="form-control "/>
                                                <span class="input-group-addon">元</span>
                                            </div>
                                        </td>
                                    </tr>


                                    <tr>
                                        <td>备注:</td>
                                        <td colspan="3">
                                            <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
                                                           class="form-control "/>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>健身房：</td>
                                        <td>
                                            <sys:select cssClass="input-xlarge" name="reserveVenue.id"
                                                        cssStyle="width:40%"
                                                        id="reserveVenue_id"
                                                        items="${venueList}"
                                                        value="${reserveMember.reserveVenue.id}"
                                                        itemLabel="name"
                                                        itemValue="id"
                                                        defaultValue=""
                                                        defaultLabel="请选择健身房"
                                            ></sys:select>
                                        </td>
                                        <td>卡号截止日期:</td>
                                        <td>
                                            <input name="validityend" type="text" readonly="readonly" maxlength="20"
                                                   id="validityend"
                                                   class="input-large Wdate "
                                                   value="<fmt:formatDate value="${reserveMember.validityend}" pattern="yyyy-MM-dd"/>"
                                                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                                        </td>

                                    </tr>
                                </table>

                                <div class="form-actions">
                                    <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
                                    <input id="btnCancel" class="btn" type="button" value="返 回"
                                           onclick="history.go(-1)"/>
                                </div>
                            </form:form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $('.icheck').iCheck({
            checkboxClass: 'icheckbox_square-blue checkbox',
            radioClass: 'iradio_square-blue'
        });
    });
</script>
<script src="${ctxStatic}/modules/reserve/js/reserve_timeCard_member_form.js" type="text/javascript"></script>
</body>
</html>