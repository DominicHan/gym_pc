<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="referrer" content="always"/>
    <meta charset='utf-8'/>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <meta name="format-detection" content="telephone=no"/>
    <title>里昂健身-登录</title>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/modules/reserve/css/app_login.css">
    <link href="${ctxStatic}/cleanzone/js/bootstrap/dist/css/bootstrap.css?time=21" rel="stylesheet"/>
    <script type="text/javascript" src="${ctxStatic}/cleanzone/js/jquery.js"></script>
    <script src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js" type="text/javascript"></script>
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
<div style="margin:30px auto 30px auto">
    <img src="${ctxStatic}/images/weixin_login.png" style="max-width: 260px;max-height: 140px;">
</div>
<div>
    <form id="loginForm" accept-charset="UTF-8" action="${ctx}/login" method="post">
        <input type="hidden" name="mobileLogin" value="true"/>
        <div style="margin:10px;">
            <input type="text" id="username" name="username" class="input-block-level required"
                   value="${username}"
                   placeholder="请输入手机号"/>
        </div>
        <div style="margin:10px;">
            <input type="password" id="password" name="password" class="input-block-level required"
                   placeholder="密码"/>
        </div>
        <c:if test="${isValidateCodeLogin}">
            <div style="margin: 10px;">
                <div class="validateCodeDiv">
                    <sys:appValidateCode name="validateCode"/>
                </div>
            </div>
        </c:if>

        <div style="margin:20px auto 20px auto; width:300px;">
            <div style="margin-bottom:10px;">
                <button type="submit">登录</button>
            </div>
        </div>
        <div style="margin:10px;">
            <div class="row" id="messageBox">
                <div id="loginError" style="color: red">${message}</div>
            </div>
        </div>
    </form>
</div>
</body>
</html>
