<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="name" type="java.lang.String" required="true" description="验证码输入框名称" %>
<%@ attribute name="inputCssStyle" type="java.lang.String" required="false" description="验证框样式" %>
<%@ attribute name="imageCssStyle" type="java.lang.String" required="false" description="验证码图片样式" %>
<%@ attribute name="buttonCssStyle" type="java.lang.String" required="false" description="看不清按钮样式" %>

<div class="col-lg-5" style="padding-left: 0px;">
    <input type="text" id="${name}" name="${name}" maxlength="5" class="txt required validateCodeInput"
           style="font-weight:bold;height: 40px;${inputCssStyle}"/>
</div>
<div class="col-lg-7">
    <img src="${pageContext.request.contextPath}/servlet/validateCodeServlet" onclick="$('.${name}Refresh').click();"
         class="mid ${name}" style="${imageCssStyle}"/>
    <a href="javascript:"
       onclick="$('.${name}').attr('src','${pageContext.request.contextPath}/servlet/validateCodeServlet?'+new Date().getTime());"
       class="mid ${name} Refresh" style="${buttonCssStyle}">
        <span class="form-control-static">看不清</span>
    </a>
</div>