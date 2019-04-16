<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath }"/>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>COIPIB - 注册页面</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />

    <!--全局样式表-->
    <link href="./static/css/global.css" rel="stylesheet"/>
    <%--<link rel="shortcut icon" href="./static/images/Logo_40.png" type="image/x-icon">--%>
    <link rel="stylesheet" href="./static/css/login/font.css">
    <link rel="stylesheet" href="./static/css/login/xadmin.css">

</head>

<body class="login-bg">

<div class="login layui-anim layui-anim-up">
    <div class="message">COIPIB - 注册</div>
    <div id="darkbannerwrap"></div>
    <form class="layui-form" action="" method="post">
        <input type="text" name="username" id="username" lay-verify="required|username" placeholder="请输入用户名"
               autocomplete="off" class="layui-input">
        <hr class="hr15">
        <input type="text" name="email" id="email" lay-verify="required|email" placeholder="请输入邮箱"
               autocomplete="off" class="layui-input">
        <hr class="hr15">
        <input type="password" name="password" id="password" lay-verify="required|password" placeholder="请输入密码"
               autocomplete="off" class="layui-input">
        <hr class="hr15">
        <input type="password" name="rePassword" id="rePassword" lay-verify="required" placeholder="请确认密码"
               autocomplete="off" class="layui-input">
        <hr class="hr15">
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <input type="text" name="codeCaptcha" id="codeCaptcha" lay-verify="required|codeCaptcha" placeholder="请输入验证码"
                       autocomplete="off" class="layui-input">
            </div>
            <label class="field-wrap" style="cursor:pointer;">
                <img src="" id="captchaImg" align='absmiddle' height="40px"
                     style="margin-top: 5px" onclick="changeCaptcha()">
            </label>
            <span id="code_span" style="color: green"></span>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <input type="text" name="emailCaptcha" id="emailCaptcha" lay-verify="required|emailCaptcha"  placeholder="请输入邮箱验证码"
                       autocomplete="off" class="layui-input">
            </div>
            <label class="field-wrap" style="float:left;">
                <button style="width: 100%" class="layui-btn layui-btn-radius" onclick="return sendEmail();">发送邮件</button>
            </label>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <p style="text-align: left"><a href="login.jsp">已有账号？前往登录</a></p>
            </div>
        </div>
        <button style="width: 100%" class="layui-btn layui-btn-radius" lay-submit="" lay-filter="submit">注册</button>
        <hr class="hr15" >
    </form>
</div>
<!--遮罩-->
<div class="blog-mask animated layui-hide"></div>
<!-- layui.js -->
<script src="./static/plug/layui/layui.js"></script>
<script src='./static/js/jquery/jquery.min.js'></script>
<script>
    $(function () {
        changeCaptcha();
    });
    // 更换验证码
    function changeCaptcha() {
        $.get('/codeCaptcha', function (data) {
            $("#captchaImg").attr('src', 'data:image/jpeg;base64,' + data.data.image);
        });
    }

    function sendEmail() {
        var email = $("#email").value();
        var codeCaptcha = $("#codeCaptcha").value();
        $.ajax({
            type: 'get',
            url: '/emailCaptcha',
            data: {"email": email, "codeCaptcha": codeCaptcha},
            dataType: 'json',
            success: function (data) {
                if (data.value !== 200) {
                    layer.msg(data.msg, {icon: 2});
                    changeCaptcha();
                    return false;
                }
            }
        });
        return false;
    }

    layui.use(['form', 'layer'], function(){
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.jquery;

        function checkRegisterInfo(username, email, password, rePassword, codeCaptcha, emailCaptcha) {
            if (username.trim() == "" || username.trim() == null) return "请输入用户名！";
            if (email.trim() == "" || email.trim() == null) return "请输入邮箱！";
            if (password == "" || password == null) return "请输入密码！";
            if (rePassword == "" || rePassword == null) return "请输入确认密码！";
            if (codeCaptcha == "" || codeCaptcha == null) return "请输入验证码！";
            if (emailCaptcha == "" || emailCaptcha == null) return "请输入邮箱验证码！";
            if (!(password==rePassword)) return "两次输入密码不一致！";
            return "";
        }
        //监听提交
        form.on('submit(submit)', function(){
            var username = $("#username").value();
            var email = $("#email").value();
            var password = $("#password").value();
            var rePassword = $("#rePassword").value();
            var codeCaptcha = $("#codeCaptcha").value();
            var emailCaptcha = $("#emailCaptcha").value();

            var hint = checkRegisterInfo(username, email, password, rePassword, codeCaptcha, emailCaptcha);
            if (hint != "") {
                layer.msg(hint, {icon:2});
                return false;
            }

            $.ajax({
                type: 'post',
                url: '/register',
                data: {"name": username, "email":email, "password": password, "codeCaptcha": codeCaptcha, "emailCaptcha": emailCaptcha},
                dataType: 'json',
                success: function (data) {
                    if (data.value !== 200) {
                        layer.msg(data.msg,{icon: 2});
                        changeCaptcha();
                        return false;
                    } else {
                        location = "${ctx}/";
                    }

                }
            });
            return false;
        });

        // // 自定义验证规则
        // var verifyCode = true;
        // form.verify({
        //
        //     value: function (value) {
        //         $.ajax({
        //             url: '/checkCode',
        //             data: {"value": value},
        //             dataType: 'json',
        //             async: false,
        //             success: function (data) {
        //                 var message = data['message'];
        //                 if(message === 'isNull'){
        //                     verifyCode = false;
        //                     layer.msg("缓存验证码为空，请刷新页面", {icon: 5});
        //                 }else if(message === 'codeError'){
        //                     verifyCode = false;
        //                     layer.msg("验证码错误", {icon: 5});
        //                 }else {
        //                     verifyCode = true;
        //                 }
        //             }
        //         });
        //     },
        //
        // });
    });

</script>
</body>
</html>