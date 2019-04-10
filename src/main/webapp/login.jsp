<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath }"/>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>COIPIB - 登陆页面</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4,
    initial-scale=0.8,target-densitydpi=low-dpi" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />

    <!--全局样式表-->
    <link href="./static/css/global.css" rel="stylesheet"/>
    <!--Layui-->
    <link href="static/plug/layui/css/layui.css" rel="stylesheet"/>
    <%--<link rel="shortcut icon" href="./static/images/Logo_40.png" type="image/x-icon">--%>
    <link rel="stylesheet" href="./static/css/login/font.css">
    <link rel="stylesheet" href="./static/css/login/xadmin.css">
</head>

<body class="login-bg">
<div class="login layui-anim layui-anim-up">
    <div class="message">COIPIB - 登录</div>
    <div id="darkbannerwrap"></div>
    <form class="layui-form" action="" method="post">
        <input type="text" name="username" id="username" lay-verify="required|username" placeholder="请输入用户名"
               autocomplete="off" class="layui-input">
        <hr class="hr15">
        <input type="password" name="password" id="password" lay-verify="required" placeholder="请输入密码"
               autocomplete="off" class="layui-input">
        <hr class="hr15">
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <input type="text" name="code" id="code" lay-verify="required|code" placeholder="请输入验证码"
                       autocomplete="off" class="layui-input">
            </div>
            <label class="field-wrap" style="cursor:pointer;">
                <img src="${ctx}/captchaServlet" id="captchaImg" align='absmiddle' height="40px"
                     style="margin-top: 5px" onclick="changeCaptcha()">
            </label>
            <span id="code_span" style="color: green"></span>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <p style="text-align: left"><a href="register.jsp">没有账号？前往注册</a></p>
            </div>
            <label class="field-wrap" style="cursor:pointer;">
                <p style="text-align: right"><a href="#">忘记密码？</a></p>
            </label>
        </div>
        <button style="width: 100%" class="layui-btn layui-btn-radius" lay-submit="" lay-filter="submit">登录</button>
        <hr class="hr15" >
    </form>
</div>
<!-- layui.js -->
<script src="./static/plug/layui/layui.js"></script>
<script src='./static/js/jquery/jquery.min.js'></script>
<script>

    layui.use(['form', 'layer'], function(){
        var form = layui.form;
        var layer = layui.layer;
        // 自定义验证规则
        var verifyCode = true;
        form.verify({

            code: function (value) {
                $.ajax({
                    type: 'post',
                    url: '/checkCode',
                    data: {"code": value},
                    dataType: 'json',
                    async: false,
                    success: function (data) {
                        var code = data['code'];
                        var msg = data['msg'];
                        if(code !== 200){
                            layer.msg(msg, {icon: 5});
                        }
                    }
                });
            },

        });
        //监听提交
        form.on('submit(submit)', function(){
            // if(!verifyUsername || !verifyCode){
            //     return false;
            // }
        });
    });

    // 更换验证码
    function changeCaptcha(){
        $("#captchaImg").attr('src', '${ctx}/captchaServlet?t=' + (new Date().getTime()));
    }
</script>
</body>
</html>