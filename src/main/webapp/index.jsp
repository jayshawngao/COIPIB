<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
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
    <%--分页样式表--%>
    <link href="./static/css/pageInfo/page.css" rel="stylesheet">
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo" style="font-weight: bold">COIPIB</div>
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left" >
            <li class="layui-nav-item"><a href="javascript:;">文件</a></li>
            <li class="layui-nav-item"><a href="javascript:;">编辑</a></li>
            <li class="layui-nav-item"><a href="javascript:;">文献</a></li>
            <li class="layui-nav-item"><a href="javascript:;">窗口</a></li>
            <li class="layui-nav-item"><a href="javascript:;">帮助</a></li>
            <li class="layui-nav-item"><a href="javascript:;">搜索</a></li>
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

            </ul>
        </div>
    </div>

    <div class="layui-body">
        <!-- 内容主体区域 -->

        <!--左边文章列表-->
        <div class="blog-main">
            <div class="blog-main-left">

                <div style="padding: 15px;" id="body-content-left">

                </div>
                <ul class="pager pager-loose">
                    <div id="page"></div>
                </ul>
            </div>
            <!--右边小栏目-->
            <div class="blog-main-right">
                <div style="padding: 15px;" id="body-content-right"></div>
            </div>
        </div>
        <div class="clear"></div>
    </div>

    <%--<div class="layui-footer" style="background-color: #00FF00">--%>
        <%--<!-- 底部固定区域 -->--%>
        <%--底部固定区域--%>
    <%--</div>--%>
</div>
<script src="./static/plug/layui/layui.js"></script>
<script src='./static/js/jquery/jquery.min.js'></script>
<script>
    // layui框架导航模块初始化，禁止删除
    layui.use('element', function () {
        var element = layui.element;
    });

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
            success: function (data) {

                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    return false;
                } else {
                    var affiliationList = data.data.affiliationList;
                    var html = "";
                    var affiliationId = affiliationList[0].id;
                    doClickShowDoc(affiliationId, 1);
                    affiliationList.forEach(function (element) {
                        if (element.deleted == 1) {
                            var id = element.id;
                            var name = element.name;
                            var allChildren = getAllChildren(id);
                            html = html
                                + '<li class="layui-nav-item">\n'
                                + '<a class="" href="javascript:;" onclick="doClickShowDoc(' + id + ',' + 1 + ')">'
                                + name + '</a>\n'
                                + allChildren
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
            data: {parentId: parentId},
            dataType: "json",
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    return '';
                } else {
                    var affiliationList = data.data.childrenList;
                    if (affiliationList.length > 0) html = '<dl class="layui-nav-child">';
                    affiliationList.forEach(function (element) {
                        var id = element.id;
                        if (element.deleted == 1) {
                            var name = element.name;
                            html = html + '<dd><a href="javascript:;" onclick="doClickShowDoc(' + id + ',' + 1 + ')">'
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

    function doClickShowDoc(id, curPage) {
        $.ajax({
            type: 'get',
            url: "/document/showAllDocument",
            data: {"affiliationId": id, "page": curPage},
            dataType: "json",
            success: function (data) {
                if (data.code !== 200) {
                    layer.msg(data.msg, {icon: 2});
                    return '';
                } else {
                    var htmlName = '<div class="layui-form"><table class="layui-table"><thead><tr>' +
                        '<th style="width: 8%;text-align: center">序号</th>' +
                        '<th style="width: 50%;text-align: center"">文献名</th>' +
                        '<th style="width: 14%;text-align: center"">作者</th>' +
                        '<th style="width: 14%;text-align: center"">编辑人</th>' +
                        '<th style="width: 14%;text-align: center"">更新日期</th>' +
                        '</tr></thead>';
                    var pagination = data.data.pagination;
                    var documentList = pagination.data;
                    var pageInfo = pagination.pageInfo;
                    var totalPage = pageInfo.totalPage;

                    if (documentList.length > 0) htmlName = htmlName + '<tbody>';
                    var sequence = 1;
                    documentList.forEach(function (element) {
                        var name = element.name;
                        var editor = element.editor;
                        var author = element.author;
                        var updateTime = timestampToTime(element.updateTime);
                        htmlName = htmlName + '<tr>' +
                            '<td>' + sequence + '</td>' +
                            '<td style="cursor:pointer" onclick="doClickShowInfo(' + JSON.stringify(element).replace(/\"/g,"'") + ')">' + name + '</td>' +
                            '<td>' + author + '</td>' +
                            '<td>' + editor + '</td>' +
                            '<td>' + updateTime + '</td>' +
                            '</tr>';
                        sequence++;
                    });
                    if (documentList.length > 0) htmlName = htmlName + '</tbody></table></div>';
                    $("#body-content-left").html(htmlName);

                    var htmlPage = '<li class="total-page"><a href="javascript:void(0);">共&nbsp;' + totalPage + '&nbsp;页</a></li>';
                    if (curPage <= 1) {
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);">上一页</a></li>';
                    } else {
                        curPage = curPage - 1;
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);" onclick="doClickShowDoc('
                            + id + ','
                            + curPage
                            + ')">上一页</a></li>';
                    }
                    htmlPage = htmlPage + '<li><a href="javascript:void(0);">当前页' + pageInfo.page + '</a></li>';
                    if (curPage >= pageInfo.totalPage) {
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);">下一页</a></li>';
                    } else {
                        curPage = curPage + 1;
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);" onclick="doClickShowDoc('
                            + id + ','
                            + curPage
                            + ')">下一页</a></li>';
                    }
                    $("#page").html(htmlPage);
                }
            }
        });
    }

    function doClickShowInfo(obj) {
        var topic = obj.topic;
        var year = obj.year;
        var editor = obj.editor;
        var digest = obj.digest;
        var author = obj.author;
        var name = obj.affiliationList[0].name;
        var keywords = obj.keywords;
        var html = '摘要：' + digest +
            '<br><br>关键字：' + keywords +
            '<br><br>作者：' + author +
            '<br><br>编辑人：' + editor +
            '<br><br>归属：' + name +
            '<br><br>主题：' + topic +
            '<br><br>年份：' + year;
        $("#body-content-right").html(html);
    }

    function timestampToTime(timestamp) {
        var date = new Date(timestamp);
        var Y = date.getFullYear() + '-';
        var M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
        var D = date.getDate() + ' ';
        var h = date.getHours() + ':';
        var m = date.getMinutes() + ':';
        var s = date.getSeconds();
        return Y + M + D;
    }

</script>
</body>
</html>