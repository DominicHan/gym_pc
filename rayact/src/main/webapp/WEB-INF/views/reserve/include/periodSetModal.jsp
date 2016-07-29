<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 无教练课时设置Modal -->
<button id="periodDialogButton"  style="display: none" class="btn btn-primary btn-large" href="#periodDialog"  data-toggle="modal">预订</button>
<div class="modal fade"  style="width:auto;" id="periodDialog" tabindex="-1" style="display: none"  aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width: 80%">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">无教练课时设置</h4>
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            </div>
            <div class="modal-body">
                <div class="reserve_top_line">

                </div>
                <div class="modal-body form-horizontal" id="periodSetForm">
                    <!--次卡充值-->

                    <!--end 次卡充值-->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id="closeTimeCardAddDialogBtn" class="btn btn-default btn-flat md-close" data-dismiss="modal">
                    取消
                </button>
                <button type="button" id="saveTimeCardAddDialogBtn" onclick="save()" class="btn btn-primary btn-flat">确定</button>
            </div>
        </div>
    </div>
</div>