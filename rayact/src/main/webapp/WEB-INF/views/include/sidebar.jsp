<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<div class="cl-sidebar">
    <div class="cl-navblock">
        <div style="width: 100%;background: #fff;box-sizing:border-box">
            <div class="content">
                <img style="float: right;position: relative;left:14px"
                     src="${ctxStatic}/cleanzone/images/triangle.png"/>
                <ul class="cl-vnavigation" style="position: fixed">
                </ul>
                <ul class="cl-vnavigation">
                    <c:forEach items="${fns:getAuthByUser(fns:getUser())}" var="auth">
                        <li>
                            <a href="#">
                                <div class="row">
                                    <div class="col-lg-2 col-sm-2">
                                        <img style="width:28px"
                                             src="${ctxStatic}/cleanzone/images/sidebar/${auth.code}.png"/>
                                    </div>
                                    <div class="col-lg-6 col-sm-3"><span id="${auth.code}">${auth.name}</span></div>
                                </div>
                            </a>
                            <ul class="sub-menu">
                                <c:forEach items="${auth.authorityList}" var="a">
                                    <li
                                            <j:if test="${a.code eq param.action}">class="active"</j:if> ><a
                                            href="${ctx}${a.href}"><span id="${a.code}">${a.name}</span></a></li>
                                </c:forEach>
                            </ul>
                        </li>
                    </c:forEach>
                </ul>

            </div>
        </div>
    </div>
</div>
