<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<div style="text-align: center">里昂健身</div>
<table class="no-border">
    <tbody class="no-border-y">
    <tr>
        <td style="border-bottom:0;">姓名：${venueCons.userName}</td>
    </tr>
    <tr>
        <td style="border-bottom:0;">场馆：${venueCons.reserveVenue.name}</td>
    </tr>
    <tr>
        <td style="border-bottom:0;">收银员：${venueCons.updateBy.name}</td>
    </tr>
    <tr>
        <td style="border-bottom:0;"><fmt:formatDate value="${venueCons.updateDate}" type="both"/></td>
    </tr>
    <c:forEach items="${venueCons.venueConsList}" var="item">
        <tr>
            <td class="no-border-bottom">教练：${item.reserveField.name}</td>
            <td class="no-border">预订时间：${item.startTime}-${item.endTime}</td>
            <td class="no-border">费用：${item.orderPrice}</td>
        </tr>
    </c:forEach>
    <tr>
        <td class="no-border">应收：${venueCons.shouldPrice}</td>
        <td class="no-border">优惠：${venueCons.discountPrice}</td>
        <td class="no-border">实收：${venueCons.consPrice}</td>
    </tr>
    <tr>
        <td class="no-border">余额：${venueCons.member.remainder}</td>
        <td class="no-border">剩余教练课时：${venueCons.member.tutorPeriodResidue}</td>
        <td class="no-border">剩余无教练课时：${venueCons.member.residue}</td>
    </tr>
    </tbody>
</table>