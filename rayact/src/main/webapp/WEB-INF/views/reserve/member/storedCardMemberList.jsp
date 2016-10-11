<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <meta name="decorator" content="main"/>
    <title>预储值列表</title>
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
                    <h3>预储值列表</h3>
                </div>
                <form:form id="searchForm" modelAttribute="reserveMember" action="${ctx}/reserve/storedCardMember/list"
                           method="post">
                    <div class="breadcrumb form-search">
                        <div class="row">
                            <div class="col-sm-10 col-md-10 col-lg-10">
                                <table class="no-border">
                                    <tbody class="no-border-y">
                                    <ul class="ul-form">
                                        <td>姓名：</td>
                                        <td><form:input path="name" htmlEscape="false" maxlength="30"
                                                        class="form-control"/></td>

                                        <td>手机号：</td>
                                        <td><form:input path="mobile" htmlEscape="false" maxlength="20"
                                                        class="form-control"/>
                                        </td>

                                        <td>卡号：</td>
                                        <td><form:input path="cardno" htmlEscape="false" maxlength="20"
                                                        class="form-control"/>
                                        </td>
                                        <td><input id="btnSubmit" class="btn btn-primary" type="submit"
                                                   value="查询"/></td>

                                    </ul>
                                    </tbody>
                                </table>
                            </div>
                            <div class="pull-right">
                                <a class="btn btn-success" href="${ctx}/reserve/storedCardMember/form">
                                    <i class="fa fa-plus"></i>添加
                                </a>
                            </div>
                        </div>
                    </div>
                    <sys:msg content="${message}"/>
                    <div class="content">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                <tr>
                                    <th>健身房</th>
                                    <th>年卡</th>
                                    <th>姓名</th>
                                    <th>手机号</th>
                                    <th>卡号</th>
                                    <th>余额</th>
                                    <th>操作</th>
                                    <th>交易</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${page.list}" var="reserveMember">
                                    <tr>
                                        <td>
                                                ${reserveMember.reserveVenue.name}
                                        </td>
                                        <td>
                                                ${fns:getDictLabel(reserveMember.annualCardFlag, 'yes_no', '')}
                                        </td>
                                        <td><a href="${ctx}/reserve/storedCardMember/form?id=${reserveMember.id}">
                                                ${reserveMember.name}
                                        </a></td>
                                        <td>
                                                ${fns:hidePhone(reserveMember.mobile)}
                                        </td>
                                        <td>
                                                ${reserveMember.cardno}
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${reserveMember.remainder}"/>

                                        </td>
                                        <td>
                                            <a class="btn btn-primary btn-xs"
                                               href="${ctx}/reserve/storedCardMember/form?id=${reserveMember.id}"><i
                                                    class="fa fa-pencil"></i>修改</a>
                                            <a class="btn btn-danger btn-xs"
                                               href="${ctx}/reserve/storedCardMember/delete?id=${reserveMember.id}"
                                               onclick="return confirmb('确认要删除该会员吗？', this.href)"><i
                                                    class="fa fa-times"></i>删除</a>

                                        </td>
                                        <td>
                                            <a class="btn btn-primary btn-xs rechargeBtn" data-id="${reserveMember.id}"><i
                                                    class="fa fa-pencil"></i>充值</a>
                                            <a class="btn btn-primary btn-xs refundBtnForVIP"
                                               data-id="${reserveMember.id}"><i
                                                    class="fa fa-pencil"></i>退费</a>
                                            <a class="btn btn-primary btn-xs"
                                               href="${ctx}/reserve/reserveMember/statements?reserveMember.id=${reserveMember.id}">交易明细</a>
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
<button id="rechargeDialogBtn" style="display: none" class="btn btn-primary btn-large"
        href="#rechargeDialog" data-toggle="modal">付款成功
</button>
<div class="modal fade" id="rechargeDialog" style="display: none;" aria-hidden="true">
    <div class="modal-dialog" style="width: 80%">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">充值</h4>
                <button type="button" class="close" data-dismiss="modal"><span
                        aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            </div>
            <div class="modal-body">
                <div class="reserve_top_line">

                </div>
                <div class="modal-body form-horizontal" id="rechargeForm">
                    <!--付款成功模态-->
                    <!--end 付款成功模态-->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button"  class="btn btn-default btn-flat md-close"
                        data-dismiss="modal">
                    取消
                </button>
                <button type="button" id="rechargeSaveBtn"
                        class="btn btn-primary btn-flat">
                    确定
                </button>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../include/refundModal.jsp"></jsp:include>
<script src="${ctxStatic}/modules/reserve/js/storedcard_member_list.js" type="text/javascript"></script>
</body>
</html>
