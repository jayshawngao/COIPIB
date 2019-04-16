<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath }"/>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>COIPIB - 找回密码</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4,
    initial-scale=0.8,target-densitydpi=low-dpi"/>
    <meta http-equiv="Cache-Control" content="no-siteapp"/>

    <!--全局样式表-->
    <link href="./static/css/global.css" rel="stylesheet"/>
    <!--Layui-->
    <link href="static/plug/layui/css/layui.css" rel="stylesheet"/>
    <%--<link rel="shortcut icon" href="./static/images/Logo_40.png" type="image/x-icon">--%>
    <link rel="stylesheet" href="./static/css/login/font.css">
    <link rel="stylesheet" href="./static/css/login/xadmin.css">
</head>

<body class="login-bg">
<div class="login layui-anim layui-anim-up" style="min-height: 0;">
    <div class="message">COIPIB - 找回密码</div>
    <div id="darkbannerwrap"></div>
    <form class="layui-form" action="" method="post">
        <input type="text" name="nameEmail" id="nameEmail" placeholder="请输入注册邮箱"
               autocomplete="off" class="layui-input">
        <hr class="hr15">
        <button style="width: 100%;" class="layui-btn layui-btn-radius" lay-filter="submit" lay-submit="">找回密码</button>
    </form>
</div>
<!-- layui.js -->
<script src="./static/plug/layui/layui.js"></script>
<script src='./static/js/jquery/jquery.min.js'></script>
<script>
    layui.use(['form', 'layer'], function() {
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.jquery;

        function checkLoginInfo(nameEmail, password, codeCaptcha) {
            if (nameEmail.trim() == "" || nameEmail.trim() == null) return "请输入注册邮箱！";
            return "";
        }

        //监听提交
        form.on('submit(submit)', function(){
            var nameEmail = $("#nameEmail").val();

            var hint = checkLoginInfo(nameEmail);
            if (hint != "") {
                layer.msg(hint, {icon:2});
                return false;
            }

            <%--$.ajax({--%>
                <%--type: 'post',--%>
                <%--url: '/login',--%>
                <%--data: {"nameEmail": nameEmail, "password": password, "codeCaptcha": codeCaptcha},--%>
                <%--dataType: 'json',--%>
                <%--success: function (data) {--%>
                    <%--if (data.code !== 200) {--%>
                        <%--layer.msg(data.msg,{icon: 2});--%>
                        <%--changeCaptcha();--%>
                        <%--return false;--%>
                    <%--} else {--%>
                        <%--location = "${ctx}/";--%>
                    <%--}--%>

                <%--}--%>
            <%--});--%>
            return false;
        });
    });

</script>
</body>
</html>