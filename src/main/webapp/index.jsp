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
            <li class="layui-nav-item layui-this"><a href="javascript:;" onclick="showAllDocuments();">文件</a></li>
            <li class="layui-nav-item"><a href="javascript:;" onclick="showEditableDocs();">编辑</a></li>
            <li class="layui-nav-item" id="adminMenu">

            </li>
        </ul>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item" id="loginButton" style="display: none;"><a href="/login">登录</a></li>
            <li class="layui-nav-item" id="userInfoButton" style="display: none; margin-right: 20px;"></li>
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
            <!--左边栏目-->
            <div class="blog-main-left" id="blog-main-left">
                <div style="padding: 15px;" id="body-content-left">

                </div>
                <ul class="pager pager-loose">
                    <div id="page"></div>
                </ul>
            </div>
            <!--右边栏目-->
            <div class="blog-main-right" id="blog-main-right">
                <div style="padding: 15px;" id="body-content-right"></div>
            </div>
            <div id="showPdf" style="width: 100%;"></div>
        </div>
        <div class="clear"></div>
    </div>

    <div class="layui-footer">
        <!-- 底部固定区域 -->
        <button class="layui-btn layui-btn-primary layui-btn-sm" id="back" style="display: none" onclick="clickBackBtn();">
            <i class="fa fa-chevron-left" aria-hidden="true"></i>
        </button>
    </div>
</div>
<input type="hidden" id="isEdit" value="false">
<input type="hidden" id="isActive" value="false">
<script src="./static/plug/layui/layui.js"></script>
<script src='./static/js/jquery/jquery.min.js'></script>
<script src='./static/js/pdfobject.js'></script>
<script>

    // js全局变量
    var userInfo = {};
    userInfo.id = "${user.id}";
    userInfo.name = "${user.name}";
    userInfo.email = "${user.email}";
    userInfo.level = "${user.level}";
    userInfo.active = "${user.active}";

    // layui框架导航模块初始化，禁止删除
    var layer;
    layui.use(['element', 'layer'], function () {
        var element = layui.element;
        layer = layui.layer
    });

    $(function () {
        getFirstLayer();
        checkUserLogin();
    });

    // 点击导航栏“编辑”
    function showEditableDocs() {
        clearVerticalMenuCSS();
        $("#isActive").val("false");
        $("#isEdit").val("true");
        var affiliationId = String($("#verticalMenu > li:nth-child(1) > a").attr("id"));
        affiliationId = affiliationId.substr(15);
        doClickShowDoc(affiliationId, 1);
        $("#body-content-right").html("");
    }

    // 点击导航栏“文件”
    function showAllDocuments() {
        clearVerticalMenuCSS();
        $("#isActive").val("false");
        $("#isEdit").val("false");
        var affiliationId = String($("#verticalMenu > li:nth-child(1) > a").attr("id"));
        affiliationId = affiliationId.substr(15);
        doClickShowDoc(affiliationId, 1);
        $("#body-content-right").html("");
    }

    function clearVerticalMenuCSS() {
        var ele = $("#verticalMenu");
        ele.children("li").each(function (i, childEle) {
            $(childEle).removeClass("layui-nav-itemed");
            $(childEle).removeClass("layui-this");
        });
        ele.children("dd").each(function (i, childEle) {
            $(childEle).removeClass("layui-this");
        });
    }

    // 显示用户信息
    function checkUserLogin() {
        if (userInfo.id != null && userInfo.id != -1) {
            $("#loginButton").hide();
            var html = "";
            html = html + '<a href="javascript:;">' + userInfo.name + '</a>'
                + '<dl class="layui-nav-child">'
                + '<dd><a href="javascript:;">基本资料</a></dd>'
                + '<dd><a href="javascript:;">修改密码</a></dd>'
                + '<hr>'
                + '<dd><a href="javascript:;">退出</a></dd>'
                + '</dl>';
            $("#userInfoButton").html(html);
            $("#userInfoButton").show();
        } else {
            $("#loginButton").show();
            $("#userInfoButton").hide();
        }

        if (userInfo != null && userInfo.level == 3) {
            var html = "";
            html = html + '<a href="javascript:;">管理员</a>\n' +
                '                <dl class="layui-nav-child">\n' +
                '                    <dd><a href="javascript:;">文献审核</a></dd>\n' +
                '                    <dd><a href="javascript:;">用户管理</a></dd>\n' +
                '                </dl>'
            $("#adminMenu").html(html);
        }
    }

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
                                + '<a class="" href="javascript:;" id="affiliationList' + id
                                + '" onclick="doClickShowDoc(' + id + ',' + 1 + ')">'
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
        var isEdit = $("#isEdit").val();
        var isActive = $("#isActive").val();
        $.ajax({
            type: 'get',
            url: "/document/showAllDocument",
            data: {"affiliationId": id, "page": curPage, "isEdit": isEdit, "isActive": isActive},
            dataType: "json",
            success: function (data) {
                if (data.code !== 200) {
                    layer.msg(data.msg, {icon: 2});
                    return '';
                } else {
                    var htmlName = '<div class="layui-form"><table class="layui-table"><thead><tr>' +
                        '<th style="width: 6%;text-align: center">序号</th>' +
                        '<th style="width: 42%;text-align: center"">文献名</th>' +
                        '<th style="width: 8%;text-align: center"">预览</th>' +
                        '<th style="width: 10%;text-align: center"">作者</th>' +
                        '<th style="width: 10%;text-align: center"">编辑人</th>' +
                        '<th style="width: 14%;text-align: center"">更新日期</th>';
                    if (isEdit == "true" && isActive == "false") {
                        htmlName = htmlName + '<th style="width: 14%;text-align: center"">操作</th>';
                    }
                    htmlName = htmlName + '</tr></thead>';
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
                        var attachment = element.attachment;
                        var updateTime = timestampToTime(element.updateTime);
                        htmlName = htmlName + '<tr>' +
                            '<td style="text-align: center;">' + sequence + '</td>' +
                            '<td><a style="cursor:pointer" onclick="doClickShowInfo(' + JSON.stringify(element).replace(/\"/g,"'") + ')">' + name + '</a></td>' +
                            '<td style="text-align: center;"><a style="display: block; cursor: pointer; color: blue;" onclick="doclickShowPdf(\''+attachment+'\')">预览</a></td>' +
                            '<td style="text-align: center;">' + author + '</td>' +
                            '<td style="text-align: center;">' + editor + '</td>' +
                            '<td style="text-align: center;">' + updateTime + '</td>';
                        if (isEdit == "true" && isActive == "false") {
                            if (id != 200) {
                                htmlName = htmlName + '<td style="text-align: center;"><a style="display: block; cursor: pointer; color: blue;">编辑</a>'
                                    + '<a style="display: block; cursor: pointer; color: blue;" href="javascript:;" onclick="doClickRemoveDocToBin(' + element.id + ',' + id + ',' + curPage + ')">放入回收站</a>'
                                    + '</td>';
                            }else {
                                htmlName = htmlName + '<td style="text-align: center;"><a style="display: block; cursor: pointer; color: blue;" onclick="doClickRecoverDoc(' + element.id + ',' + id + ',' + curPage + ')">还原</a>'
                                    + '<a style="display: block; cursor: pointer; color: blue;" href="javascript:;" onclick="doClickDeleteDoc(' + element.id + ',' + id + ',' + curPage + ')">永久删除</a>'
                                    + '</td>';
                            }
                        }
                        htmlName = htmlName + '</tr>';
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
                    htmlPage = htmlPage + '<li><a href="javascript:void(0);">当前页&nbsp;' + pageInfo.page + '</a></li>';
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

    function doclickShowPdf(attachment){
        document.getElementById("blog-main-left").style.display = "none";
        document.getElementById("blog-main-right").style.display = "none";
        var height = window.innerHeight - 67;
        document.getElementById("showPdf").style.height = height + "px";
        PDFObject.embed(attachment, "#showPdf");
        $("#showPdf").show();
        $("#back").show();
    }

    function clickBackBtn() {
        $("#blog-main-left").show();
        $("#blog-main-right").show();
        $("#showPdf").hide();
        $("#back").hide();
    }

    function doClickShowInfo(obj) {
        var documentName = obj.name;
        var topic = obj.topic;
        var year = obj.year;
        var editor = obj.editor;
        var digest = obj.digest;
        var author = obj.author;
        var name = obj.affiliationList[0].name;
        var keywords = obj.keywords;
        var createTime = timestampToTime(obj.createTime);
        var updateTime = timestampToTime(obj.updateTime);
        var html = '标题：' + documentName +
            '<br><br>摘要：' + digest +
            '<br><br>关键字：' + keywords +
            '<br><br>文献作者：' + author +
            '<br><br>编辑人：' + editor +
            '<br><br>文献归属：' + name +
            '<br><br>文献主题：' + topic +
            '<br><br>文献年份：' + year +
            '<br><br>创建时间：' + createTime +
            '<br><br>修改时间：' + updateTime;
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

    // 文件放入回收站
    function doClickRemoveDocToBin(docId, affiliationId, curPage) {
        $.ajax({
            type: 'get',
            url: "/document/remove",
            data: {"id": docId},
            dataType: "json",
            success: function (data) {
                if (data.code !== 200) {
                    layer.msg(data.msg,{icon: 2});
                    return '';
                } else {
                    layer.msg(data.msg, {icon: 1});
                    doClickShowDoc(affiliationId, curPage);
                    return;
                }
            }
        });
    }

    // 回收站文件永久删除
    function doClickDeleteDoc(docId, affiliationId, curPage) {
        $.ajax({
            type: 'get',
            url: "/document/delete",
            data: {"id": docId},
            dataType: "json",
            success: function (data) {
                if (data.code !== 200) {
                    layer.msg(data.msg,{icon: 2});
                    return '';
                } else {
                    layer.msg(data.msg, {icon: 1});
                    doClickShowDoc(affiliationId, curPage);
                    return;
                }
            }
        });
    }

    // 回收站文件还原
    function doClickRecoverDoc(docId, affiliationId, curPage) {
        $.ajax({
            type: 'get',
            url: "/document/recover",
            data: {"id": docId},
            dataType: "json",
            success: function (data) {
                if (data.code !== 200) {
                    layer.msg(data.msg,{icon: 2});
                    return '';
                } else {
                    layer.msg(data.msg, {icon: 1});
                    doClickShowDoc(affiliationId, curPage);
                    return;
                }
            }
        });
    }

</script>
</body>
</html>