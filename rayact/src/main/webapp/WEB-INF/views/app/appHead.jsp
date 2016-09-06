<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<div style="background-color:#fff;padding:10px;border-bottom:1px solid rgb(178,178,178);">
    <table border="0" width="100%">
        <tbody>
        <tr>
            <td onclick="javascript:history.back(-1)" width="30px"><img
                    src="${ctxStatic}/images/weiXin_return.png"
                    style="margin-bottom:-2px;" height="22px"></td>
            <td align="center" valign="middle">
                <div style="padding:5px 0"><img
                        src="${ctxStatic}/images/weiXin_logo.png"
                        style="display:block" height="16px"></div>
            </td>
            <td width="30px">&nbsp;<a href="${ctx}/logout"><img
                    src="${ctxStatic}/images/weiXin_logout.png" style="margin-bottom:-2px;"
                    height="22px"></a></td>
        </tr>
        </tbody>
    </table>
</div>