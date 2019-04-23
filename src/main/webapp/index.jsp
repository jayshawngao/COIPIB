<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; Charset=gb2312">
    <meta http-equiv="Content-Language" content="zh-CN">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <title>COIPIB</title>
    <link rel="stylesheet" href="./static/plug/layui/css/layui.css">
    <!--font-awesome-->
    <link href="./static/plug/font-awesome/css/font-awesome.min.css" rel="stylesheet"/>
    <!--全局样式表-->
    <link href="./static/css/global.css" rel="stylesheet"/>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo" style="font-weight: bold">COIPIB</div>
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">
            <li class="layui-nav-item"><a href="">文件</a></li>
            <li class="layui-nav-item"><a href="">编辑</a></li>
            <li class="layui-nav-item"><a href="">文献</a></li>
            <li class="layui-nav-item"><a href="">窗口</a></li>
            <li class="layui-nav-item"><a href="">帮助</a></li>
            <li class="layui-nav-item"><a href="">搜索</a></li>
        </ul>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item"><a href="/login">登录</a></li>
            <li class="layui-nav-item">
                <input type="text" name="" class="layui-input" id="" placeholder="请输入：关键字">
            </li>
            <li class="layui-nav-item">
                <button class="layui-btn" lay-submit="" lay-filter="formSearch">搜索</button>
            </li>
        </ul>
    </div>

    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree" lay-filter="test" id="verticalMenu">
                <%--<li class="layui-nav-item layui-nav-itemed layui-this">--%>
                    <%--<a class="" href="javascript:void(0);" onclick="doClickName('一带一路')">一带一路</a>--%>
                <%--</li>--%>
                <%--<li class="layui-nav-item layui-nav-itemed">--%>
                    <%--<a href="javascript:void(0);" onclick="doClickName('东南亚与南亚')">东南亚与南亚</a>--%>
                <%--</li>--%>
                <%--<li class="layui-nav-item layui-nav-itemed">--%>
                    <%--<a href="javascript:void(0);" onclick="doClickName('非洲')">非洲</a>--%>
                <%--</li>--%>
                <%--<li class="layui-nav-item layui-nav-itemed">--%>
                    <%--<a href="javascript:void(0);" onclick="doClickName('中东与西亚')">中东与西亚</a>--%>
                <%--</li>--%>
                <%--<li class="layui-nav-item layui-nav-itemed">--%>
                    <%--<a href="javascript:void(0);" onclick="doClickName('其他')">其他</a>--%>
                <%--</li>--%>
                <%--<li class="layui-nav-item layui-nav-itemed">--%>
                    <%--<a href="javascript:void(0);" onclick="doClickName('未分类')">未分类</a>--%>
                <%--</li>--%>
                <%--<li class="layui-nav-item layui-nav-itemed">--%>
                    <%--<a href="javascript:void(0);" onclick="doClickName('回收站')">回收站</a>--%>
                <%--</li>--%>
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <!-- 内容主体区域 -->

        <!--左边文章列表-->
        <div class="blog-main">
            <div class="blog-main-left" style="background-color: #00acd8">
                <div style="padding: 15px;" id="body-content-left"> 一带一路 左边</div>
            </div>
            <!--右边小栏目-->
            <div class="blog-main-right" style="background-color: orange">
                <div style="padding: 15px;" id="body-content-right">一带一路 右边</div>
            </div>
        </div>
        <div class="clear"></div>
    </div>

    <div class="layui-footer" style="background-color: #00FF00">
        <!-- 底部固定区域 -->
        底部固定区域
    </div>
</div>
<script src="./static/plug/layui/layui.js"></script>
<script src='./static/js/jquery/jquery.min.js'></script>
<script>
    $(function () {
        getFirstLayer();
    });

    // 获取一级菜单并显示
    function getFirstLayer() {
        $.ajax({
            async: false,
            type: "get",
            url: "/affiliation/showFirstLayer",
            dataType: "json",
            success:function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg,{icon: 2});
                    return false;
                } else {
                    var affiliationList = data.data.affiliationList;
                    var html = "";
                    affiliationList.forEach(function (element) {
                        if (element.deleted == 1) {
                            var id = element.id;
                            var name = element.name;
                            var allChildren = getAllChildren(element.id);
                            html = html + '<li class="layui-nav-item layui-nav-itemed layui-this">\n'
                                + '<a class="" href="javascript:void(0);" onclick="doClickName(\'' + id + '\')">' + name + '</a>\n'
                                + allChildren;
                                + '</li>\n';
                        }
                    });
                    $("#verticalMenu").html(html);
                }
            }
        });
    };
    // 根据parentId获取二级菜单并返回html
    function getAllChildren(parentId) {
        var html = '';
        $.ajax({
            async: false,
            type: "post",
            url: "/affiliation/showNextLayer",
            data: {parentId : parentId},
            dataType: "json",
            success:function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg,{icon: 2});
                    return '';
                } else {
                    var affiliationList = data.data.childrenList;
                    if (affiliationList.length > 0) html = '<dl class="layui-nav-child">';
                    affiliationList.forEach(function (element) {
                        var id = element.id;
                        if (element.deleted == 1) {
                            var name = element.name;
                            html = html + '<dd><a href="javascript:void(0);" onclick="doClickName(\'' + id + '\')">'
                                + name
                                + '</a></dd>\n';
                        }
                    });
                    if (affiliationList.length > 0) html = html + '</dl>';
                }
            }
        });
        return html;
    }

    function doClickName(id) {
        var html = '';
        $.ajax({
            type: 'post',
            url: "/document/showAllDocument",
            data: {"affiliationId": id},
            dataType: "json",
            success:function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg,{icon: 2});
                    return '';
                } else {
                    var documentList = data.data.documentList;
                    if (documentList.length > 0) html = '<tr>';
                    documentList.forEach(function (element) {
                        var name = element.name;
                        html = html + '<td>' + name + '</td>';
                    });
                    if (documentList.length > 0)  html =  html + '</tr>';
                }
            }
        });
        return html;
        /*$("#body-content-left").text(id + "左边");
        $("#body-content-right").text(id + " 右边");*/
        <%--location = "${ctx}/index?name=" + name;--%>
    }

    //JavaScript代码区域
    layui.use('element', function () {
        var element = layui.element;

    });
</script>
</body>
</html>