<%@ page pageEncoding="UTF-8"%>

<!-- progress bar -->
<div id="dlg_progress" class="easyui-dialog" style="width:420px;height:'auto';padding:10px 15px" closed="true">
    <div id="progressFileName" style="float: left;padding-right:10px;"></div>
    <div id="progressBar" class="easyui-progressbar" style="height:16px;width :370px;float: left;"></div>
    <div id="progressTip" style="float: left;padding-left:10px;">
        <div class="readSizeTitle" id="readSizeTitle">
            已上传/总大小：<span id="readSizeText"></span>
            &nbsp;速度：<span id="speedText">0KB</span>/s
            &nbsp;耗时：<span id="useTimeText">0s</span>
            &nbsp;剩余时间：<span id="expectCompleteTimeText">0s</span>
            &nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-no" id="btn_pause">取消</a>
        </div>
    </div>
</div>
