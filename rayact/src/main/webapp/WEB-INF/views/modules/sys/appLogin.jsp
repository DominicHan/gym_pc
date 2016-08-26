<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>${fns:getConfig('productName')} 登录</title>
    <meta name="decorator" content="blank"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/modules/reserve/css/app_login.css">
    <script src="${ctxStatic}/flash/zoom.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#loginForm").validate({
                rules: {
                    validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
                },
                messages: {
                    username: {required: "请填写用户名."}, password: {required: "请填写密码."},
                    validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
                },
                errorLabelContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    error.appendTo($("#loginError").parent());
                }
            });
        });
        // 如果在框架或在对话框中，则弹出提示并跳转到首页
        if (self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0) {
            alert('未登录或登录超时。请重新登录，谢谢！');
            top.location = "${ctx}";
        }
    </script>
</head>
<body>

<form id="loginForm" action="${ctx}/login" method="post">
    <input type="hidden" name="mobileLogin" value="true"/>
    <div class="login_form">
        <div class="row">
            <input type="text" id="username" name="username" class="input-block-level required"
                   value="${username}"
                   placeholder="请输入手机号"/>
        </div>
        <div class="row">
            <input type="password" id="password" name="password" class="input-block-level required"
                   placeholder="密码"/>
        </div>
        <c:if test="${isValidateCodeLogin}">
            <div class="row" style="margin-bottom: 10px;width: 690px">
                <div class="validateCode">
                    <sys:validateCode name="validateCode"/>
                </div>

            </div>
        </c:if>
        <div class="row" style="margin-bottom: 20px">
            <div id="messageBox">
                <div id="loginError" style="color: red">${message}</div>
            </div>
        </div>
        <div class="row">
            <input class="btn btn-large btn-primary"
                   style="width:690px;height: 80px; border-radius: 5px;background-color:#990707;border-color:#990707"
                   type="submit"
                   value="登 录"/>
        </div>
    </div>
</form>
</body>
</html>