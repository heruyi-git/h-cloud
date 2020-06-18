var fileStore = {srcPath:'',opMode:0,key:null};
var isZtreeRightClick = false; //是否为树右击
var editRenameRow = {index:null,oldName:null}; // 重命名编辑时的行索引和名称

// 获取当前目录文件
function getCurFilePath(){
    var filePath = $("#filePath2").combobox('getText');
    if (!!!filePath){
        var nodes = zTree.getSelectedNodes();
        var parentNode = null;
        if(nodes.length>0){
            parentNode = nodes[0];
            filePath = parentNode.id;
        }
    }
    console.log("getCurFilePath is :" + filePath);
    return filePath;
}

// 获取上级目录
function getUpPath(){
    var upPath = "";
    var filePath = getCurFilePath();
    if(!!filePath){
        var nodes = zTree.getNodesByParam("id", filePath, null);
        if (nodes.length>0) {
            // 选中节点
            var parentNode = zTree.getNodeByTId(nodes[0].parentTId);
            if (!!parentNode) {
                upPath = parentNode.id;
            }
        }
        if (upPath == "") {
            var parentNode;
            var lastIndexOf = filePath.lastIndexOf("\\");
            if (lastIndexOf != -1) {
                parentNode = filePath.substr(0, lastIndexOf);
                if (!!parentNode) {
                    upPath = parentNode;
                }
            }
        }
    }
    return upPath;
}

// 获取当前树选中节点
function getCurTreeNode(){
    var nodes = zTree.getNodesByParam("id", getCurFilePath(), null);
    if (nodes.length > 0){
        var curNode = nodes[0];
        console.log("getCurTreeNode is :" + curNode);
        return curNode;
    } else {
        console.log("getCurTreeNode is null");
        return null;
    }
}

// 选中地址栏filePath2目录   --- 当选中地址栏时会触发combobox的onChange事件去调用selectZTreeNode
function selectAddressBar(filePath){
    if(!!filePath){
        util.combobox("#filePath2",["value","label"],
            [{label: filePath,value: filePath}]
        );
    }
}

// 选中ztree目录文件节点
function selectZTreeNode(filePath){
    if(!!filePath){
        var nodes = zTree.getNodesByParam("id", filePath, null);
        if (nodes.length>0) {
            // 选中节点
            zTree.selectNode(nodes[0]);
            //doQuery(newValue);
        }else{
            // 向下找不到节点,则取消当前节点,树是异步的没有展开该选中的节点
            zTree.cancelSelectedNode();
            // 需要在展开时默认选中  ---  详见ztree的onAsyncSuccess
        }
    }
}



// 刷新
function refresh(id){
    // 刷新树
   refreshZtree(id);
    // 同步列表
   doQuery();
   // 取消选中
    $('#dg_file').datagrid('clearSelections').datagrid('clearChecked');
}


// ------------------------------------------------------- 文件操作-------------------------------------------------
function newFolder(){
    //$('#dlg_newFolder').dialog('open').dialog('center').dialog('setTitle','新建文件夹');
    // ztree addnode
    var nodes = zTree.getSelectedNodes();
    var parentNode = nodes[0];
    var newNode = {id:parentNode.id+"/新建文件夹",name:"新建文件夹",isParent:true};
    newNode = zTree.addNodes(parentNode, newNode);
}

// 新建文件夹和文件  -------  都按照filePath目录来
function newFile(resource){
    var id = getCurFilePath();  // 当前目录

    ///console.log(id);
    var fileName;
    var showMsg = "新建失败";
    if(resource=="folder"){
        fileName = "新建文件夹";
        $.post("newFolder.json",{baseDirs:id,dirs:fileName},function(result){
            if(!!result){
                //fileName = result.data;
                //var newNode = {id:id+"/"+fileName,name:fileName,isParent:true};
                //newNode = zTree.addNodes(parentNode, newNode);
                // 直接刷新节点-保存新建节点ID以便获得焦点
                newNodeId = result.data;//result.data.replace(/\\/g,'/');
                newNodeId2 = newNodeId;
                refresh('load_tree');
                showMsg = result.msg;
            }
            $.messager.show({
                title: '操作提示',
                msg: showMsg
            });
        });
        //alert(document.activeElement.tagName);
    }else if(resource=="txt"){
        fileName = "新建文本文档.txt";
        $.post("newFile.json",{baseDirs:id,fileName:fileName},function(result){
            if(!!result){
                fileName = result.data;
                //var newNode = {id:id+"/"+fileName,name:fileName};
                //newNode = zTree.addNodes(parentNode, newNode);
                // 直接刷新节点-保存新建节点ID以便获得焦点
                newNodeId = result.data;//result.data.replace(/\\/g,'/');
                newNodeId2 = newNodeId;
                refresh('load_tree');
                showMsg = result.msg;
            }
            $.messager.show({
                title: '操作提示',
                msg: showMsg
            });
        });
        //util.newDialog("dlg_newFile","http://www.qq.com","新建"+resource, 400, 300,'icon-file');
    }
    //
}

// 新建目录  --- 暂时没用
function doNewFolder(){
    $("#fm_newFolder").find("input[name='baseDirs']").val($("#filePath2").combobox('getText'));
    $('#fm_newFolder').form('submit',{
        url: "newFolder.json",
        onSubmit: function(){
            return $(this).form('validate');
        },
        success: function(msg){
            var result = eval('('+msg+')');
            if (result.msg){
                $.messager.show({
                    title: '操作提示',
                    msg: result.msg
                });
                refresh('local_tree');
                $('#dg_file').datagrid('reload');    // reload the user data
            } else {
                $.messager.show({
                    title: '操作提示',
                    msg: '操作失败'
                });
            }
            $('#dlg_newFolder').dialog('close');        // close the dialog
        }
    });
}

// 删除文件
function doDel() {
    // 获取当前操作的元素
    //获取选中行的数据
    var selectRows = $('#dg_file').datagrid('getChecked');
    if (selectRows.length < 1) {
        $.messager.alert("提示消息", "请选择要删除的记录！", 'info');
        return;
    }
    $.messager.confirm("确认消息", "确定要删除所选记录吗？", function (r) {
        if (r) {
            var strIds = "";
            for (var i = 0; i < selectRows.length; i++) {
                strIds += selectRows[i].id + ",";
            }
            strIds = strIds.substr(0, strIds.length - 1);
            $.post('doDel.json',{ids:strIds}, function (msg) {
                if (msg.msg) {
                    $.messager.show({
                        title: '操作提示',
                        msg: msg.msg
                    });
                    refresh('local_tree');
                    $('#dg_file').datagrid('clearSelections').datagrid('clearChecked');
                    $('#dg_file').datagrid('reload');
                }
            }, 'json').error(function(msg) {
                $.messager.alert('提示', '操作失败请刷新后重试！','error');
            });
        }
    });
}

// 下载文件
function downFile() {
    var row = $('#dg_file').datagrid('getSelected');
    if (row){
        if(row.fileType!=1) {
            window.location.href = "down?filePath=" +  encodeURIComponent(row.filePath);
        }
    }
}


// rename
function rename(){
    // 获得文件名单元格焦点进行重命名编辑
    if (isZtreeRightClick) {
        var nodes = zTree.getSelectedNodes();
        if (nodes.length > 0 ) {
            zTree.editName(nodes[0]);
        }
    }else{
        var dg_file = $('#dg_file');
        var row = dg_file.datagrid('getSelected');
        if (row){
            var curEditRowIndex = dg_file.datagrid('getRowIndex',row);
            dg_file.datagrid('beginEdit',curEditRowIndex);
            var ed = dg_file.datagrid('getEditor', { index: curEditRowIndex, field: 'fileName' });
            if(ed){
                $(ed.target).focus();
                editRenameRow.index = curEditRowIndex;
                editRenameRow.oldName = row.fileName;
            }
        }
    }
}


//copy
function copy(){
    var nodes = zTree.getSelectedNodes();
    $.post("copy.json",{srcId:'common.commonFile.index',srcPath:nodes[0].id},function(result){
        //eval("result="+result);
        if(!!result){
            // 激活粘贴menu
            fileStore.srcPath = nodes[0].id;
            fileStore.opMode = 1;
            fileStore.key = result.data;
        }
        $.messager.show({
            title: '操作提示',
            msg: result.msg
        });
    });
}

//cut
function cut(){
    var nodes = zTree.getSelectedNodes();
    $.post("cut.json",{srcId:'common.commonFile.index',srcPath:nodes[0].id},function(result){
        //eval("result="+result);
        if(!!result){
            // 激活粘贴menu
            fileStore.srcPath = nodes[0].id;
            fileStore.opMode = 2;
            fileStore.key = result.data;
        }
        $.messager.show({
            title: '操作提示',
            msg: result.msg
        });
    });
}

//paste
function paste(){
    if(fileStore.key==null){
        return;
    }
    var nodes = zTree.getSelectedNodes();
    $.post("paste.json",{srcId:'common.commonFile.index',destDir:nodes[0].id},function(result){
        //eval("result="+result);
        if(!!result){
            // 粘贴重置数据--刷新节点
            if(fileStore.opMode==2){
                // 剪切时删除原节点
                var srcNodes = zTree.getNodesByParam('id',fileStore.srcPath,null);
                zTree.removeNode(srcNodes[0]);
            }
            fileStore.srcPath = '';
            fileStore.key = null;
            fileStore.opMode = 0;
            // 刷新目标节点
            refresh();
        }
        $.messager.show({
            title: '操作提示',
            msg: result.msg
        });
    });
}


// open add and edit window
var url;
function doOpen(fileType,filePath,file){
    var fileName = file;
    var filePath = filePath;
    if (!!!fileName || !!!filePath) {
        var row = $('#dg_file').datagrid('getSelected');
        if (row) {
            if (row.fileType != 1) {
                fileName = row.fileName;
                filePath = row.filePath;
            }
        } else {
            var nodes = zTree.getSelectedNodes();
            if (!!nodes) {
                fileName = nodes[0].name;
                filePath = nodes[0].id;
            }
        }
    }

    if (!!!filePath){
        return;
    }

    // $("#ifm")[0].src = '/static/js/trumbowyg/editor.html';
    var ed = $("#ifm")[0].contentWindow.ed; //$("#ifm").contents().find("#content"); //$('#content');
    var fm = $("#ifm").contents().find("#fm");
    util.newWindow("#dlg",fileName+' - 编辑窗口',fm,500,200,null,function () {
        ed.trumbowyg('empty');
    });
    $.messager.progress();
    //ed.trumbowyg('disable');
    //$('#dlg').dialog('center');
    $.post("openFile.json",{filePath:filePath,fileType:fileType},function(result){
        fm.find("input[name='filePath']").val(filePath);
        $.messager.progress('close');
        //ed.trumbowyg('enable');
        if(!!result && result.code == 0) {
            if (fileType == 16) {
                ed.trumbowyg('html', result.data);
            }else if (fileType == 2){
                ed.trumbowyg('html', "<img src='"+constant.imgSrcPrefix + result.data+"'/>");
            }else{
                $.messager.alert('提示','暂不支持文件类型','info');
            }
        }
    });
}

function toEdit(){
    $('#parentCode_span').html("编辑菜单");
    var row = $('#dg_file').datagrid('getSelected');
    if (row){
        $('#dlg').dialog('open').dialog('center').dialog('setTitle','编辑');
        $('#fm').form('load',row);
        url = 'doEdit.json';
    }
}

function doSave(){
    $('#fm').form('submit',{
        url: url,
        onSubmit: function(){
            return $(this).form('validate');
        },
        success: function(msg){
            var result = eval('('+msg+')');
            if (result.msg){
                $.messager.show({
                    title: '操作提示',
                    msg: result.msg
                });
                refresh('treeDemo');
                $('#dg_file').datagrid('reload');    // reload the user data
            } else {
                $.messager.show({
                    title: '操作提示',
                    msg: '操作失败'
                });
            }
            $('#dlg').dialog('close');        // close the dialog
        }
    });
}

// 顶页
function topUp() {
    $("#fileName2").textbox('setValue','');
    zTree.cancelSelectedNode();
    util.combobox("#filePath2",["value","label"],
        [{label: '',value: ''}]
    );
    doQuery();
}
// 向上一级目录
function up(){
    // 清空输入框文件名
    $("#fileName2").textbox('setValue','');
    //
    var filePath = getCurFilePath();
    if(!!filePath){
        // 树向上 , 异步加载的树没有展开目录对应的节点，找不到选中节点则按目录截取控制刷新数据---------
        var nodes = zTree.getNodesByParam("id", filePath, null);
        if (nodes.length>0) {
            // 选中节点
            var parentNode = zTree.getNodeByTId(nodes[0].parentTId);
            if (!!parentNode) {
                zTree.selectNode(parentNode);
            }else{
                // 向上找不到节点，则取消当前节点
                zTree.cancelSelectedNode(nodes[0]);
            }
        }

        // 地址栏向上， 后期都采用目录方式控制数据，不采用树来控制数据
        var parentNode;
        var lastIndexOf = filePath.lastIndexOf("\\");
        if (lastIndexOf != -1){
            parentNode = filePath.substr(0,lastIndexOf);
            // 选中节点--异步没有节点可选
            // zTree.selectNode(parentNode);
            // 改变路径
            if(!!parentNode){
                util.combobox("#filePath2",["value","label"],
                    [{label: parentNode,value: parentNode}]
                );
            }else{
                // 顶级目录
                util.combobox("#filePath2",["value","label"],
                    [{label: '',value: ''}]
                );
            }
            // 重新加载数据
            doQuery(parentNode);
        }
    }
}

// 点击文件
function onClickFile(fileType,filePath){
    if(fileType!=1){
        // 不是目录，禁用上传文件按钮
        // $('#btn_file').attr("disabled",true);
        // $('#a_file').menubutton({
        //     iconCls: 'icon-upload_gray'
        // });
        var dir;
        var file;
        var lastIndexOf = filePath.lastIndexOf("\\");
        if (lastIndexOf > 0) {
            dir = filePath.substr(0, lastIndexOf);
            file = filePath.substr(lastIndexOf+1,filePath.length);
        }
        selectAddressBar(dir);
        doOpen(fileType,filePath,file);
        //$("#fileName2").textbox('setValue',file);
        //doQuery(dir,file);
    }else{
        $('#btn_file').attr("disabled",false);
        $('#a_file').menubutton({
            iconCls: 'icon-upload'
        });
        $("#fileName2").textbox('setValue','');
        console.log(filePath+"-->");
        selectAddressBar(filePath);
        doQuery(filePath);
    }
}

// Ztree的右键单击文件
function onRightClickFile(event, treeId, treeNode) {
    if(treeNode) {
        zTree.selectNode(treeNode);
        isZtreeRightClick = true;
        showRightMenu(treeNode.isParent==true ? 1 : 0);
    }
}


// dataGrid右键单击单元格
function onRowContextMenu(e, rowIndex, rowData)
{
    e.preventDefault();  //阻止浏览器的右击事件
    if(rowIndex > -1)  //点击到单元格才触发
    {
        isZtreeRightClick = false;
        var t = e.target;
        var rows = $(this).datagrid("getRows"); // 得到rows对象
        var columns = $(this).datagrid("options").columns;  // 得到columns对象
       // var inserted = $("#usergrid").datagrid('getChanges', "inserted");
       // var deleted = $("#usergrid").datagrid('getChanges', "deleted");
       // var updated = $("#usergrid").datagrid('getChanges', "updated");
        var field = $(t).closest('td').attr('field'); //获取点击单元格的列名
        var column = $(this).datagrid('getColumnOption',field);
        var title = column['title'];
        var value = rows[rowIndex][field]; //获取单元格的值
        //rows[rowIndex][field]='new value'; // 赋值

        var fileType = rowData.fileType; // 获取选中行的列fileType值
        $(this).datagrid("clearSelections"); //取消所有选中项
        var el = e.srcElement || e.target;

        //$(this).datagrid('beginEdit',rowIndex);
        //var rowdata2 = $(this).datagrid("getEditors",rowIndex);
        //alert(showMsg(rowdata2));
        //var editormodel = rowdata2[0];//rowdata2[1];
        //alert(showMsg(editormodel));
        //editormodel.target.textbox('setValue','xxx');
        //$(this).datagrid('endEdit',rowIndex);
        //$(this).datagrid('refreshRow', rowIndex); //然后刷新该行即可

        // 鼠标在SPAN上触发showRightMenu
        if (el.tagName == 'SPAN') {
        //if(field == 'fileName'){
            // 点击单元格fileName
            $(this).datagrid("selectRow", rowIndex); //根据索引选中该行
            showRightMenu(fileType);
        }else {
            // 点击空白处
            showBlankRightMenu();
            //showRightMenu(fileType);
        }
    }
}



//开始行编辑 ----------- test 编辑表格
function updateUser(){
    var row = $("#usergrid").datagrid('getSelected');
    if (row) {
        var rowIndex = $("#usergrid").datagrid('getRowIndex', row);
        $("#usergrid").datagrid('beginEdit', rowIndex);
        alert(formattime(row.createDate));
    }
}

// 显示右键菜单
function showRightMenu(fileType) {
    $('#mm_div_open').show();
    $('#mm_div_compress').show();
    $('#mm_div_sendto').show();
    $('#mm_div_cut').show();
    $('#mm_div_copy').show();
    $('#mm_div_rename').show();
    $('#mm_div_doDel').show();
    if(fileType == 1){
        //
        $('#mm_div_open').html('<div class="menu-text">展开(O)</div>');
        $('#mm_div_openmode').hide(); //$('#mm_div_open').remove();
        $('#mm_div_refresh').show();
        $('#mm_div_newFile').show();
        // session取复制或剪切数据
        if(!!fileStore.key){
            $('#mm_div_paste').show();
            $('#mm').menu('enableItem', $('#mm_div_paste'));
        }else{
            $('#mm_div_paste').hide();
            $('#mm').menu('disableItem', $('#mm_div_paste'));
        }
    }else{
        //
        $('#mm_div_open').html('<div class="menu-text">打开(O)</div>');
        $('#mm_div_openmode').show();
        $('#mm_div_refresh').hide();
        $('#mm_div_newFile').hide();
        $('#mm_div_paste').hide();
    }
   showMenu();
}

// 空白处显示右键菜单
function showBlankRightMenu(e) {
    // 需新增查看，排序，菜单
    $('#mm_div_open').hide();
    $('#mm_div_openmode').hide();
    $('#mm_div_compress').hide();
    $('#mm_div_sendto').hide();
    $('#mm_div_cut').hide();
    $('#mm_div_copy').hide();
    $('#mm_div_refresh').show();
    if(!!fileStore.key){
        $('#mm_div_paste').show();
        $('#mm').menu('enableItem', $('#mm_div_paste'));
    }else{
        $('#mm_div_paste').hide();
        $('#mm').menu('disableItem', $('#mm_div_paste'));
    }
    $('#mm_div_newFile').show();
    $('#mm_div_doDel').hide();
    $('#mm_div_rename').hide();

    showMenu();
}

function showMenu() {
    $('#mm').menu('show', {
        left: event.pageX,
        top: event.pageY,
        hideOnUnhover:false
    });
}

//保存 -----------  test 编辑表格
function saveGrid(){
    endEdit();
    if ($("#usergrid").datagrid('getChanges').length) {
        var inserted = $("#usergrid").datagrid('getChanges', "inserted");
        var deleted = $("#usergrid").datagrid('getChanges', "deleted");
        var updated = $("#usergrid").datagrid('getChanges', "updated");
        var effectRow = new Object();
        if (inserted.length) {
            effectRow["inserted"] = JSON.stringify(inserted);
            alert(effectRow["inserted"]);
            $.post("user_appendUser.action", effectRow, function(rsp) {
                alert("追加已提交!");
                $("#usergrid").datagrid("reload");
            });
        }
        if (deleted.length) {
            effectRow["deleted"] = JSON.stringify(deleted);
            alert("delete");
        }
        if (updated.length) {
            effectRow["updated"] = JSON.stringify(updated);
            alert(effectRow["updated"]);
            $.post("user_updateUser.action", effectRow, function(rsp) {
                alert("行编辑已提交!");
                $("#usergrid").datagrid("reload");
            });
        }
    }
}

// -------------------------------------------------------------文件上传-------------------------------------------------------------------------------------
function upload(t){
    if(t==1){
        //上传文件
        document.getElementById("btn_file").click();
    }else{
        //上传文件夹
        $.messager.alert("提示","暂未开放...");
    }
}

$(document).ready(function(){
    // 绑定上传文件提交事件
    var uploading = false;
    $('#btn_file').change(function(){
        if(uploading){
            $.messager.alert("提示","文件正在上传中，请稍候...");
            return false;
        }
        //定义表单变量
        var file = this.files;
        if(file.length<1){
            return;
        }
        //新建一个FormData对象
        var formData = new FormData($('#fileFrm')[0]);
        //追加文件数据
        for(i=0;i<file.length;i++){
            formData.append("file"+i, file[i]);
        }
        $('#dlg_progress').dialog({
            title:'文件上传进度',
            align:'center',
            closed: false,
            draggable: true,
            resizable: false,
            border:false,
            //noheader:true,
            closable:false,
            modal: true
        });

        var ajax = $.ajax({
            url: "upload.json",
            type: 'POST',
            dataType:"json",
            data: formData,
            cache: false,
            processData: false,
            contentType: false,
            beforeSend: function(){
                uploading = true;
                $('#progressBar').progressbar('setValue', 0);// 初始化进度条
            },
            complete: function () {
                uploading = false;
                $('#dlg_progress').dialog('close');
            },
            xhr: function(){ //获取ajaxSettings中的xhr对象。
                var xhr = $.ajaxSettings.xhr();
                if (xhr.upload) {
                    var previousPer = 0;
                    var previousReadBytes = 0;
                    var previousTime = new Date().getTime();
                    var useTime = 0;  // 耗时ms
                    var totalSize = null;
                    xhr.upload.addEventListener("progress", function (e) {
                        var now = new Date().getTime();
                        var interval = now-previousTime;
                        useTime += interval;
                        var loaded = e.loaded;//已经上传大小情况
                        var tot = e.total;//附件总大小
                        var per = Math.round((loaded / tot) * 100); //已经上传的百分比
                        var speed = (loaded-previousReadBytes)/(interval);  // 上传速率MS
                        if (totalSize == null){
                            totalSize = convert.bytesToSize(tot);
                        }
                        $('#progressBar').progressbar('setValue', per);
                        $('#readSizeText').text(convert.bytesToSize(loaded)+"/"+totalSize);
                        $('#speedText').text(convert.bytesToSize(speed*1000));
                        $('#useTimeText').text(convert.millisecondToDate(useTime));
                        if (previousPer != per ) {
                            var expectCompleteTime = (tot - loaded) / speed;
                            $('#expectCompleteTimeText').text(convert.millisecondToDate(expectCompleteTime));
                        }
                        //console.log(previousTime+"~"+now);
                        //console.log(loaded+"/"+tot);
                        previousReadBytes = loaded;
                        previousTime = now;
                        previousPer = per;
                    }, false);
                    return xhr;
                }
            },
            success : function(data) {
                if (data.code == 0) {
                    $.messager.show({
                        title: '操作提示',
                        msg: data.msg
                    });
                    var img = new Image();
                    img.src = constant.imgSrcPrefix +data.data;
                    $('#img1').html(img);
                    refresh('local_tree');
                } else{
                    if (data.code == 408){
                        $.messager.confirm(data.msg, '是否重新登录?', function(r){
                            if (r){
                                window.location.href = data.data;
                            }
                        });
                    }else{
                        $.messager.alert("提示",data.msg,'error');
                    }
                }
                //uploading = false;
                //$('#dlg_progress').dialog('close');
            },error : function(data){
                $.messager.alert("提示","服务器上传异常或文件超出最大限制,请参见浏览器控制台相关信息",'error');
            }
        });
        /* 开启进度条---后台方式处理进度条,配合调用start()方法暂时没用
         $('#progressFileName').text($('#btn_file').val().substr(12));
            setTimeout('start()',200);*/

        // 中断上传
        $("#btn_pause").on('click',function () {
            ajax.abort();
        });
    });

    // 后台轮询上传进度条显示,暂时没用
    function start(){
        var interval = 200;
        var value = $('#progressBar').progressbar('getValue');
        //console.log(value);
        if (value < 100){
            $.post('${path}/common/uploadProgress',{interval:interval},function(ret){
                if(!!ret){
                    //eval("ret="+ data);
                    value = ret.percent;
                    //console.log("->"+value);
                    $('#progressBar').progressbar('setValue', value);
                    $('#readSizeText').text(ret.readSize+"/"+ret.totalSize);
                    $('#speedText').text(ret.speed);
                    setTimeout('start()', interval);
                }else{
                    $('#dlg_progress').dialog('close');
                }
            });
        }
    }

    // 禁用或开启文件上传按钮
    function updateUploadBtnStatus() {
        var uploadDir = $("#fileFrm").find("input[name='uploadDir']").val();
        if(!!!uploadDir){
            $('#btn_file').attr("disabled",true);
            $('#a_file').menubutton({
                iconCls: 'icon-upload_gray'
            });
        }else{
            $('#btn_file').attr("disabled",false);
            $('#a_file').menubutton({
                iconCls: 'icon-upload'
            });
        }
    }

    // 绑定回车事件
    //util.bindDOMEnterEvent('qf', 'input', doQuery);
    var t = $('#fileName2');
    t.textbox('textbox').bind('keydown', function(e){
        if (e.keyCode == 13){
            t.textbox('setValue', $(this).val());  //手动赋值
            doQuery();
        }
    });
    //
    //util.bindComboboxEnterEvent('filePath2',doQuery);

    // 绑定改变事件--反向联动tree
    $('#filePath2').combobox({
        onChange:function(newValue,oldValue){
            // 设置上传目录，  目前和filePath2值一样
            $("#fileFrm").find("input[name='uploadDir']").val(newValue);
            // 同步tree节点选中
            selectZTreeNode(newValue);
        }
    });

    // 绑定回车事件--反向联动tree
    var target = $('#filePath2').combobox('textbox');
    $(target).unbind("keydown");
    $(target).keydown(function (event) {
        if (event.keyCode == 13) {
            $.messager.show({
                title: '操作提示',
                msg: $("#filePath2").combobox('getText')+"~"+$("#filePath2").combobox('getValue')
            });
            //if(selectedValue)
        }
    });

});

