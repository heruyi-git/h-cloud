$(function() {
    // 特效
    $('#login #password').focus(function() {
        $('#owl-login').addClass('password');
    }).blur(function() {
        $('#owl-login').removeClass('password');
    });

    // 验证码
    imgVer({
        el:'$("#imgVer")',
        width:'260',
        height:'116',
        img:[
            '/static/js/login/images/ver/ver-1.png',
            '/static/js/login/images/ver/ver-2.png',
            '/static/js/login/images/ver/ver-3.png',
            '/static/js/login/images/ver/ver-4.png',
            '/static/js/login/images/ver/ver-5.png',
            '/static/js/login/images/ver/ver-6.png',
            '/static/js/login/images/ver/ver-7.png',
            '/static/js/login/images/ver/ver-8.png',
            '/static/js/login/images/ver/ver-9.png',
            '/static/js/login/images/ver/ver-10.png',
            '/static/js/login/images/ver/ver-11.png',
            '/static/js/login/images/ver/ver-12.png',
            '/static/js/login/images/ver/ver-13.png'
        ],
        success:function () {
            // 拼图成功回调
            $.ajax({
                url:'/doLogin.json',
                type:'post',
                data: $('#fm').serialize(),
                success:function (res) {
                    var result = res.result;
                    if (result.code == 0){
                        location.href='front/index.html';
                    } else{
                        $(".login").css({"left":"0","opacity":"1"});
                        $(".verBox").css({"left":"404px","opacity":"0"});
                        $("#tipMsg").html(result.msg);
                    }
                },
                error:function () {
                }
            });
        },
        error:function () {
        }
    });

    // 表单提交
    $('#btn_login').on('click',function () {
        if($("#email").val() == '') {
            $("#tipMsg").html('请输入用户名！');
        } else if($("#password").val() == '') {
            $("#tipMsg").html('请输入密码！');
        } else {
            $.ajax({
                url:'validateCode.json',
                type:'get',
                success:function (result) {
                    $('#validateCode').val(result.data);
                    $(".login").css({"left":"-404px","opacity":"0" });
                    $(".verBox").css({"left":"0", "opacity":"1" });
                },
                error:function () {
                    $('#validateCode').val("");
                }
            });
        }
    });
});
