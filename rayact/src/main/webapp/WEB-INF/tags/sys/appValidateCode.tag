<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="name" type="java.lang.String" required="true" description="验证码输入框名称" %>
<%@ attribute name="inputCssStyle" type="java.lang.String" required="false" description="验证框样式" %>
<%@ attribute name="imageCssStyle" type="java.lang.String" required="false" description="验证码图片样式" %>
<%@ attribute name="buttonCssStyle" type="java.lang.String" required="false" description="看不清按钮样式" %>
<div class="row">
    <div class="col-xs-6">
        <input type="text" id="${name}" name="${name}" maxlength="5" class="txt required validateCodeInput"
               placeholder="请输入验证码"
               style="${inputCssStyle}"/>
    </div>
    <div class="col-xs-6">
        <a href="javascript:"
           onclick="$('.${name}').attr('src','${pageContext.request.contextPath}/servlet/validateCodeServlet?'+new Date().getTime());"
           class="mid ${name} Refresh" style="${buttonCssStyle}">

                <img src="${pageContext.request.contextPath}/servlet/validateCodeServlet"
                     onclick="$('.${name}Refresh').click();"
                     class="mid validateCodeImg ${name}" style="${imageCssStyle}"/>
        </a>
    </div>
</div>