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
    <%--网页图标--%>
    <link rel="shortcut icon" href="static/images/COIPIB.png" type="image/x-icon">
    <!--font-awesome-->
    <link href="./static/plug/font-awesome/css/font-awesome.min.css" rel="stylesheet"/>
    <!--全局样式表-->
    <link href="./static/css/global.css" rel="stylesheet"/>
    <%--分页样式表--%>
    <link href="./static/css/pageInfo/page.css" rel="stylesheet">
    <%--index页样式--%>
    <link href="./static/css/index.css" rel="stylesheet">

</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <a href="${ctx}/index">
            <div class="layui-logo doc-logo" style="font-weight: bold">COIPIB</div>
        </a>
        <ul class="layui-nav layui-layout-left small-head-nav-left">
            <li class="layui-nav-item"><a href="javascript:;"></a></li>
        </ul>
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left head-nav-left">
            <li class="layui-nav-item layui-this"><a href="javascript:;"
                                                     onclick="doClickHorizontalMenu('false', 'false');">文件</a></li>
            <li class="layui-nav-item"><a href="javascript:;" onclick="doClickHorizontalMenu('false', 'true');">编辑</a>
            </li>
            <li class="layui-nav-item"><a href="${ctx}/docOperation">文献操作</a></li>
            <!--禁止删除-->
            <li class="layui-nav-item" id="adminMenu">

            </li>
        </ul>

        <ul class="layui-nav layui-layout-right head-nav-right">
            <li class="layui-nav-item doc-login" id="loginButton" style="display: none;"><a href="${ctx}/login">登录</a>
            </li>
            <li class="layui-nav-item" id="userInfoButton" style="display: none; margin-right: 20px;"></li>
            <li class="layui-nav-item">
                <input type="text" name="" class="layui-input doc-search" id="simSearchKey" placeholder="请输入：关键字">
            </li>
            <li class="layui-nav-item">
                <button class="layui-btn" lay-submit="" lay-filter="formSearch" onclick="doClickSimplySearch();" id="simpleSearch">搜索
                </button>
            </li>
        </ul>

        <a class="small-doc-navicon" href="javascript:;" onclick="showLeftNav();">
            <i class="fa fa-navicon"></i>
        </a>
    </div>

    <div class="layui-side layui-bg-black left-nav-index">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree" lay-filter="test" id="verticalMenu">

            </ul>
        </div>
    </div>

    <div class="layui-body left-nav-body">
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
        <button class="layui-btn layui-btn-primary layui-btn-sm" id="back" style="display: none"
                onclick="clickBackBtn();">
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
    var authEnum = ["游客可见", "注册用户可见", "VIP用户可见", "管理员可见"];

    // layui框架导航模块初始化，禁止删除
    var layer, element;
    layui.use(['element', 'layer'], function () {
        element = layui.element;
        layer = layui.layer;
    });

    $(function () {
        getFirstLayer();
        checkUserLogin();
    });

    $('#simSearchKey').on('keypress',function (event) {
        if(event.keyCode == 13) {
            $('#simpleSearch').trigger('click');
        }

    })

    // 点击水平导航栏“编辑”、“文件”、“文件审核”显示文件
    function doClickHorizontalMenu(isActive, isEdit) {
        if (isActive == "false" && isEdit == "true" && userInfo.level == 0) {
            location = '${ctx}/login';
        }
        clearVerticalMenuCSS();
        $("#isActive").val(isActive);
        $("#isEdit").val(isEdit);
        var affiliationId = String($("#verticalMenu > li:nth-child(1) > a").attr("id"));
        affiliationId = affiliationId.substr(15);
        doClickShowDoc(affiliationId, 1);
        $("#body-content-right").html("");
        if (isActive == "true" && isEdit == "false") {
            $("#adminMenu > dl").unbind("click").bind("click", function () {
                $("#adminMenu").addClass("layui-this");
            });
        }
    }

    // 切换水平导航栏时恢复垂直导航栏状态
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
        if (userInfo != null && userInfo.id != null && userInfo.id != -1) {
            $("#loginButton").hide();
            var html = "";
            html = html + '<a href="javascript:;">' + userInfo.name + '</a>'
                + '<dl class="layui-nav-child">'
                + '<dd><a href="${ctx}/updatePassword">修改密码</a></dd>'
                + '<dd style="text-align: center;"><a href="javascript:;" onclick="logout();">退出</a></dd>'
                + '</dl>';
            $("#userInfoButton").html(html);
            $("#userInfoButton").show();
        } else {
            $("#loginButton").show();
            $("#userInfoButton").hide();
        }

        if (userInfo != null && userInfo.level != null && userInfo.level == 3) {
            var html = "";
            html = html + '<a href="javascript:;">管理员</a>\n' +
                '                <dl class="layui-nav-child">\n' +
                '                    <dd><a href="javascript:;" onclick="doClickHorizontalMenu(\'true\', \'false\');">文献审核</a></dd>\n' +
                '                    <dd><a href="javascript:;" onclick="doClickShowUserManagement(1);">用户管理</a></dd>\n' +
                '                </dl>'
            $("#adminMenu").html(html);
        }
    }

    // 用户退出
    function logout() {
        $.ajax({
            type: "get",
            url: "${ctx}/reglogin/logout",
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    return false;
                } else {
                    layer.msg(data.msg, {icon: 1});
                    location = "${ctx}/";
                }
            }
        });
    }

    // 获取一级菜单并显示
    function getFirstLayer() {
        $.ajax({
            async: false,
            type: "get",
            url: "${ctx}/affiliation/showFirstLayer",
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
            url: "${ctx}/affiliation/showNextLayer",
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
            url: "${ctx}/document/showAllDocument",
            data: {"affiliationId": id, "page": curPage, "isEdit": isEdit, "isActive": isActive},
            dataType: "json",
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    console.log(data.msg);
                    return '';
                } else {
                    fillDocsTable(data, id, curPage, isEdit, isActive);
                    return '';
                }
            }
        });
    }

    // doClickShowDoc子函数，填充不同情况下的表格
    function fillDocsTable(data, id, curPage, isEdit, isActive) {
        var htmlName = '<div class="layui-form"><table class="layui-table"><thead><tr>' +
            '<th style="width: 5%;text-align: center">序号</th>' +
            '<th style="width: 35%;text-align: center"">标题</th>' +
            '<th class="doc-preview" style="width: 6%;text-align: center"">预览</th>' +
            '<th style="width: 11%;text-align: center"">密级</th>' +
            '<th style="width: 10%;text-align: center"">作者</th>' +
            '<th class="doc-editor" style="width: 10%;text-align: center"">编辑人</th>' +
            '<th class="doc-updateTime" style="width: 10%;text-align: center"">更新日期</th>';
        if ((isEdit == "true" && isActive == "false") || (isEdit == "false" && isActive == "true")) {
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
            var auth = element.auth;
            var updateTime = timestampToTime(element.updateTime);
            htmlName = htmlName + '<tr>' +
                '<td style="text-align: center;">' + sequence + '</td>' +
                '<td><a style="cursor:pointer" onclick="doClickShowInfo(' + JSON.stringify(element).replace(/\"/g,"'") + ')">' + name + '</a></td>' +
                '<td class="doc-preview" style="text-align: center;"><a class="clickAction" onclick="doclickShowPdf(\''+attachment+'\')">预览</a></td>' +
                '<td style="text-align: center;">' + authEnum[auth] + '</td>' +
                '<td style="text-align: center;">' + author + '</td>' +
                '<td class="doc-editor" style="text-align: center;">' + editor + '</td>' +
                '<td class="doc-updateTime" style="text-align: center;">' + updateTime + '</td>';
            if (isEdit == "true" && isActive == "false") {
                if (id != 200) {
                    htmlName = htmlName + '<td style="text-align: center;"><a onclick="editeDoc(\'' + element.id + '\');" class="clickAction">编辑</a>'

                        + '<a class="clickAction" href="javascript:;" onclick="doClickPerformDocActions(' + element.id + ',' + id + ',' + curPage + ', \'remove\'' + ')">放入回收站</a>'
                        + '</td>';
                } else {
                    htmlName = htmlName + '<td style="text-align: center;"><a class="clickAction" onclick="doClickPerformDocActions(' + element.id + ',' + id + ',' + curPage + ', \'recover\'' + ')">还原</a>'
                        + '<a class="clickAction" href="javascript:;" onclick="doClickPerformDocActions(' + element.id + ',' + id + ',' + curPage + ', \'delete\'' + ')">永久删除</a>'
                        + '</td>';
                }
            }
            if (isEdit == "false" && isActive == "true") {
                if (id != 200) {
                    htmlName = htmlName + '<td style="text-align: center;"><a class="clickAction" onclick="doClickPerformDocActions(' + element.id + ',' + id + ',' + curPage + ', \'active\'' + ')">通过审核</a>'
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
        htmlPage = htmlPage + '<li><a href="javascript:void(0);" id="curPageIndex" data-curpage=' + pageInfo.page + ' data-affid=' + id + '>当前页&nbsp;' + pageInfo.page + '</a></li>';
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

    // 显示所有用户
    function doClickShowUserManagement(curPage) {
        var levelEnum = ["普通用户", "VIP用户", "管理员"];
        $.ajax({
            type: 'get',
            url: "${ctx}/reglogin/showAllUser",
            data: {"page": curPage},
            dataType: "json",
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    console.log(data.msg);
                    return false;
                } else {
                    var htmlName = '<div class="layui-form"><table class="layui-table"><thead><tr>' +
                        '<th style="width: 6%;text-align: center">序号</th>' +
                        '<th style="width: 6%;text-align: center">用户名</th>' +
                        '<th style="width: 42%;text-align: center"">邮箱</th>' +
                        '<th style="width: 8%;text-align: center"">级别</th>' +
                        '<th style="width: 10%;text-align: center"">操作</th>';
                    htmlName = htmlName + '</tr></thead>';
                    var pagination = data.data.pagination;
                    var userList = pagination.data;
                    var pageInfo = pagination.pageInfo;
                    var totalPage = pageInfo.totalPage;

                    if (userList.length > 0) htmlName = htmlName + '<tbody>';
                    var sequence = 1;
                    userList.forEach(function (element) {
                        var name = element.name;
                        var email = element.email;
                        var level = element.level;
                        htmlName = htmlName + '<tr>' +
                            '<td style="text-align: center;">' + sequence + '</td>' +
                            '<td style="text-align: center;">' + name + '</td>' +
                            '<td style="text-align: center;">' + email + '</td>' +
                            '<td style="text-align: center;">' + levelEnum[level - 1] + '</td>' +
                            '<td style="text-align: center;">';
                        if (level <= 1) {
                            htmlName = htmlName + '<a class="clickAction" href="javascript:;" onclick="doClickGrantVIP(' + element.id + ',' + curPage + ');">升级用户</a>';
                        } else {
                            htmlName = htmlName + '升级用户';
                        }
                        htmlName = htmlName + '</td></tr>';
                        sequence++;
                    });
                    if (userList.length > 0) htmlName = htmlName + '</tbody></table></div>';
                    $("#body-content-left").html(htmlName);

                    var htmlPage = '<li class="total-page"><a href="javascript:void(0);">共&nbsp;' + totalPage + '&nbsp;页</a></li>';
                    if (curPage <= 1) {
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);">上一页</a></li>';
                    } else {
                        curPage = curPage - 1;
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);" onclick="doClickShowUserManagement('
                            + curPage
                            + ')">上一页</a></li>';
                    }
                    htmlPage = htmlPage + '<li><a href="javascript:void(0);">当前页&nbsp;' + pageInfo.page + '</a></li>';
                    if (curPage >= pageInfo.totalPage) {
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);">下一页</a></li>';
                    } else {
                        curPage = curPage + 1;
                        htmlPage = htmlPage + '<li><a href="javascript:void(0);" onclick="doClickShowUserManagement('
                            + curPage
                            + ')">下一页</a></li>';
                    }
                    $("#page").html(htmlPage);
                }
            }
        });
    }

    function doclickShowPdf(attachment) {
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
        var name = obj.name;
        var topic = obj.topic;
        var year = obj.year;
        var editor = obj.editor;
        var digest = obj.digest;
        var author = obj.author;
        var note = obj.note;
        var auth = obj.auth;
        var affiliation = obj.affiliationList[0].name;
        if (obj.affiliationList[1] != null) {
            affiliation += "->" + obj.affiliationList[1].name;
        }
        var keywords = obj.keywords;
        var createTime = timestampToDate(obj.createTime);
        var updateTime = timestampToDate(obj.updateTime);
        var html = '标题：' + name +
            '<br><br>作者：' + author +
            '<br><br>摘要：' + digest +
            '<br><br>关键字：' + keywords +
            '<br><br>主题：' + topic +
            '<br><br>归属：' + affiliation +
            '<br><br>备注：' + note +
            '<br><br>密级：' + authEnum[auth] +
            '<br><br>年份：' + year +
            '<br><br>编辑人：' + editor +
            '<br><br>创建时间：' + createTime +
            '<br><br>修改时间：' + updateTime;
        $("#body-content-right").html(html);
    }

    function timestampToTime(timestamp) {
        var date = new Date(timestamp);
        var Y = date.getFullYear() + '-';
        var M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
        var D = date.getDate() + ' ';
        return Y + M + D;
    }

    function timestampToDate(timestamp) {
        var date = new Date(timestamp);
        var Y = date.getFullYear() + '-';
        var M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
        var D = date.getDate() + ' ';
        var h = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
        var m = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
        var s = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds();
        return Y + M + D + h + ':' + m + ":" + s;
    }

    // 实现文件操作：放入回收站、回收站文件永久删除、回收站文件还原、文件审核
    function doClickPerformDocActions(docId, affiliationId, curPage, action) {
        var interface = "${ctx}/document/" + action;
        $.ajax({
            type: 'get',
            url: interface,
            data: {"id": docId},
            dataType: "json",
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    return '';
                } else {
                    layer.msg(data.msg, {icon: 1});
                    doClickShowDoc(affiliationId, curPage);
                    return;
                }
            }
        });
    }

    // 升级VIP用户操作
    function doClickGrantVIP(userId, curPage) {
        var e = e || window.event;
        var obj = e.target || e.srcElement;
        $.ajax({
            type: 'get',
            url: '${ctx}/reglogin/grantVIP',
            data: {"id": userId},
            dataType: "json",
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    return false;
                } else {
                    layer.msg(data.msg, {icon: 1});
                    doClickShowUserManagement(curPage);
                    return;
                }
            }
        });
    }

    // 搜索文件
    function doClickSimplySearch() {
        var key = $("#simSearchKey").val();
        var isEdit = $("#isEdit").val();
        var isActive = $("#isActive").val();
        var curPage = $("#curPageIndex").data("curpage");
        var affiliationId = $("#curPageIndex").data("affid");
        $.ajax({
            type: 'get',
            url: '${ctx}/document/simpleSearch',
            data: {"name": key, "page": curPage, "isEdit": isEdit, "isActive": isActive},
            dataType: "json",
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    return false;
                } else {
                    fillDocsTable(data, affiliationId, curPage, isEdit, isActive);
                    $("#simSearchKey").val("");
                    clearVerticalMenuCSS();
                    return '';
                }
            }
        });
    }

    function editeDoc(docId) {
        location.href = '${ctx}/docOperation';
        window.localStorage.setItem('docId', docId);
    }

    var leftNavFlag = false;
    function showLeftNav() {
        if(leftNavFlag == false){
            $(".left-nav-index").show();
            leftNavFlag = true;
        }else{
            $(".left-nav-index").hide();
            leftNavFlag = false;
        }

    }
</script>
</body>
</html>