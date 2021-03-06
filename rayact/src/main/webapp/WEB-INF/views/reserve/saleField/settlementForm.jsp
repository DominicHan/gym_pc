<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<form id="settlementDetailFormBean">
    <input type="hidden" id="id" name="id" value="${order.id}"/>
    <input type="hidden" id="token" name="token" value="${token}"/>
    <div class="content">
        <table>
            <thead>
            <th>健身房</th>
            <th>预定人</th>
            <th>手机号</th>
            <th>教练</th>
            <th>开始时间</th>
            <th>结束时间</th>
            <th>课时</th>
            <th>教练费用</th>
            </thead>
            <tbody>
            <c:forEach items="${itemList}" var="item" varStatus="status">
                <tr>
                    <td>
                            ${item.reserveVenue.name}
                    </td>
                    <td>
                            ${member.reserveVenue.name}-${order.userName}
                    </td>
                    <td>
                            ${order.consMobile}
                    </td>
                    <td>
                            ${item.reserveField.name}
                    </td>
                    <td>
                            ${item.startTime}
                    </td>
                    <td>
                            ${item.endTime}
                    </td>
                    <td>
                            ${item.periodNum}


                    </td>
                    <td>
                            ${item.consPrice}
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr/>
    <div class="row">
        <label class="col-lg-2">预订人备注信息:</label>
        <div class="col-lg-4">
            ${member.remarks}
        </div>
        <label class="col-lg-2">剩余（教练）课时有效期:</label>
        <div class="col-lg-4">
            <fmt:formatDate value="${member.tutorPeriodValidityStart}" type="date"/>
            <input type="hidden" id="tutorPeriodValidityStart"
                   value="<fmt:formatDate value="${member.tutorPeriodValidityStart}" type="date"/>"/>
            至
            <fmt:formatDate value="${member.tutorPeriodValidityEnd}" type="date"/>
            <input type="hidden" id="tutorPeriodValidityEnd"
                   value=" <fmt:formatDate value="${member.tutorPeriodValidityEnd}" type="date"/>"/>
        </div>
    </div>
    <hr/>
    <div class="row">
        <label class="col-lg-2">订单备注:</label>
        <div class="col-lg-10">
            <input id="remarks" value="${order.remarks}" type="text" class="form-control"/>
        </div>
    </div>
    <hr/>
    <div class="row" id="payTypeDIV">
        <label for="memberCardRadio" class="col-lg-2">支付方式:</label>
        <div class="col-lg-10">
            <label class="radio-inline">
                <input type="radio" class="icheck" id="reservePeriodRadio"
                        <j:if test="${!(member.reserveVenue.id eq itemList[0].reserveVenue.id)}"> disabled="disabled" </j:if>
                        <j:if test="${member.reserveVenue.id eq itemList[0].reserveVenue.id}"> checked="checked" </j:if>
                       value="11" name="payType"/>预储课时
            </label>

            <label class="radio-inline">
                <input type="radio" class="icheck" id="memberCardRadio"
                       <j:if test="${'1' eq order.consType}">disabled="disabled"</j:if> value="1" name="payType"/>预储值
            </label>
            <label class="radio-inline pull-right">
                    温馨提示：预储课时不可跨店使用
            </label>
        </div>
    </div>

    <j:if test="${!empty giftList}">
        <hr/>
        <div class="row">
            <label class="col-lg-1" for="gift">赠品:</label>
            <div id="gift">
                <c:forEach items="${giftList}" var="gift">
                    <div class="col-lg-1">${gift.gift.name} * ${gift.num}</div>
                </c:forEach>
            </div>
        </div>
    </j:if>
    <div class="row">
        <hr/>
        <label for="shouldPrice" class="col-lg-1 col-sm-2">应收:</label>
        <div class="col-lg-1 col-sm-2">
            <input readonly="readonly" value="0" type="text"
                   id="shouldPrice" class="form-control"
                   name="shouldPrice"/>
        </div>
        <div class="col-lg-4 col-sm-4" id="discountPriceDiv" style="display:none">
            <div class="row">
                <label class="col-lg-3 col-sm-3" for="discountPrice">优惠:</label>
                <div class="col-lg-6 col-sm-6">
                    <input type="text" id="discountPrice" placeholder="请输入优惠金额后，点击确认优惠" value="0"
                           onblur="editPrice()"
                           onafterpaste="editPrice()"
                           class="form-control " name="discountPrice"/>
                </div>
                <div class="col-lg-3 col-sm-3">
                    <button type="button" onclick="editPrice()" class="btn btn-info">确认优惠</button>
                </div>
            </div>
        </div>
        <label for="consPrice" class="col-lg-1 col-sm-2">实收: <a style="cursor: hand" id="editOrderPrice">
            <li class="fa fa-edit" onclick="changePrice()"></li>
        </a></label>
        <div class="col-lg-1 col-sm-2">
            <input type="text" readonly="readonly" id="consPrice" value="0"
                   class="form-control required number" name="consPrice"/>
        </div>
        <label for="remainder" class="col-lg-1">会员余额:</label>
        <div class="col-lg-1 col-sm-2">
            <input readonly="readonly" value="${member.remainder}" type="text" id="remainder"
                   class="form-control"/>
        </div>
        <label for="tutorPeriodResidue" class="col-lg-1">应扣课时:</label>
        <div class="col-lg-1 col-sm-2">
            <input readonly="readonly" value="${order.periodCnt}" type="text" id="periodNum"
                   class="form-control"/>
        </div>
        <label for="tutorPeriodResidue" class="col-lg-2">会员剩余（教练）课时:</label>
        <div class="col-lg-1 col-sm-2">
            <input readonly="readonly" value="${member.tutorPeriodResidue}" type="text" id="tutorPeriodResidue"
                   class="form-control"/>
        </div>
    </div>
    <div class="row" id="changePrice" style="display: none">
        <hr/>
        <label for="authUser" class="col-lg-1 col-sm-2">授权人:</label>
        <div class="col-lg-1 col-sm-2">
            <sys:select id="authUser" cssClass="form-control" name=""
                        defaultLabel="请选择"
                        defaultValue=""
                        items="${authUserList}"
                        value="${cons.checkOutUser.id}"
                        itemLabel="name"
                        itemValue="id"
            ></sys:select>
        </div>
        <label for="authPassword" class="col-lg-1 col-sm-2">授权码:</label>
        <div class="col-lg-1 col-sm-2">
            <input id="authPassword" type="password" class="form-control"/>
        </div>
        <label>
            <button type="button" onclick="checkAuthorization()" class="btn btn-info">验证</button>
        </label>
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function () {
        $("#reservePeriodRadio").on('ifChecked', function () {
            $("#shouldPrice").val("0");
            $("#consPrice").val("0");
            $("#editOrderPrice").hide();
        });
        $("#memberCardRadio").on('ifChecked', function () {
            $("#shouldPrice").val(${order.shouldPrice});
            $("#consPrice").val(${order.consPrice});
            $("#periodNum").val("0");
            $("#editOrderPrice").show();
        });
    })
</script>