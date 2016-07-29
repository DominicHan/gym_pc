<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<form id="formBean">
    <input type="hidden" name="id" value="${reserveVenueVisitorsSet.id}"/>
    <input type="hidden" name="token" value="${token}"/>
    <div class="content">
        <table class="no-border">
            <tbody class="no-border-y">
            <tr>
                <td>健身房：</td>
                <td>
                    <sys:select cssClass="select2" name="reserveVenue.id" id="reserveVenueId"
                                cssStyle="width:80%"
                                value="${reserveVenueVisitorsSet.reserveVenue.id}"
                                items="${reserveVenues}"
                                defaultLabel="请选择"
                                defaultValue=""
                                itemLabel="name" itemValue="id"></sys:select>
                </td>
                <td>项目：</td>
                <td>
                    <sys:select cssClass="select2" name="project.id"
                                id="projectId"
                                value="${reserveVenueVisitorsSet.project.id}"
                                cssStyle="width:80%"
                                items="${projects}"
                                itemLabel="name"
                                itemValue="id"
                                defaultLabel="请选择"
                                defaultValue=""
                    ></sys:select>
                </td>
            </tr>
            <tr>
                <td>课时名称：</td>
                <td>
                    <input type="text" class="form-control required" value="${reserveVenueVisitorsSet.name}" id="period_name"
                           name="name"/>
                </td>
                <td>是否启用：</td>
                <td>
                    <input type="checkbox" name="available" value="1"
                           <j:if test="${'1' eq reserveVenueVisitorsSet.available}">checked="checked"</j:if>
                           class="icheck"/>
                </td>
            </tr>
            <tr>
                <td>价格：</td>
                <td>
                    <input type="text" class="form-control number required" value="${reserveVenueVisitorsSet.price}" id="period_price"  style="width:80%"
                           name="price"/>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</form>