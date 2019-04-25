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
    <%--当前页样式--%>
    <link href="./static/css/addDoc.css" rel="stylesheet"/>
</head>
<body>
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <a href="${ctx}/index"><div class="layui-logo" style="font-weight: bold">COIPIB</div></a>
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">
            <li class="layui-nav-item layui-this"><a href="javascript:;">文献操作</a></li>
        </ul>
    </div>
</div>
<div style="padding: 20px; background-color: #3f3f3f;">
    <div class="layui-row layui-col-space15 panel-doc ">
        <div class="layui-col-md8">
            <div class="layui-card">
                <div class="layui-card-header" id="op-document">新增文献</div>
                <div class="layui-card-body">
                    <form class="layui-form" action="">
                        <div class="layui-form-item">
                            <label class="layui-form-label">文献名称
                                <scan>*</scan>
                            </label>
                            <div class="layui-input-block">
                                <input type="text" name="name" id="name" lay-verify="required" autocomplete="off"
                                       placeholder="请输入文献名称" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">文献作者
                                <scan>*</scan>
                            </label>
                            <div class="layui-input-block">
                                <input type="text" name="author" id="author" lay-verify="required" autocomplete="off"
                                       placeholder="请输入文献作者" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item layui-form-text">
                            <label class="layui-form-label">文献摘要
                                <scan>*</scan>
                            </label>
                            <div class="layui-input-block">
                                <textarea name="digest" id="digest" lay-verify="required"
                                          placeholder="请输入文献摘要" class="layui-textarea"></textarea>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">文献关键字
                                <scan>*</scan>
                            </label>
                            <div class="layui-input-block">
                                <input type="text" name="keywords" id="keywords" lay-verify="required"
                                       autocomplete="off"
                                       placeholder="请输入文献关键字" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">文献主题
                                <scan>*</scan>
                            </label>
                            <div class="layui-input-block">
                                <input type="text" name="topic" id="topic" lay-verify="required" autocomplete="off"
                                       placeholder="请输入文献主题" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">文献归属
                                <scan>*</scan>
                            </label>
                            <div class="layui-input-inline">
                                <select name="affiliation_1" id="affiliation_1" lay-filter="affiliation-parent">
                                </select>
                            </div>
                            <div class="layui-input-inline">
                                <select name="affiliation_2" id="affiliation_2">
                                </select>
                            </div>
                        </div>

                        <div class="layui-upload layui-form-item" style="margin-left: 30px">
                            <button type="button" class="layui-btn layui-btn-normal" id="test8">选择文件</button>
                            <button type="button" class="layui-btn" id="test9">开始上传</button>
                        </div>

                        <div class="layui-form-item layui-form-text">
                            <label class="layui-form-label">文献备注</label>
                            <div class="layui-input-block">
                                <textarea name="note" id="note" placeholder="请输入文献备注" class="layui-textarea"></textarea>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">用户密级
                                    <scan>*</scan>
                                </label>
                                <div class="layui-input-inline">
                                    <select name="auth" id="auth">
                                        <option value="">请选择密级</option>
                                        <option value="0" id="auth_0">0 - 游客可见</option>
                                        <option value="1" id="auth_1">1 - 注册用户可见</option>
                                        <option value="2" id="auth_2">2 - VIP可见</option>
                                        <option value="3" id="auth_3">3 - 管理员可见</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">文献年份
                                <scan>*</scan>
                            </label>
                            <div class="layui-input-inline">
                                <input type="tel" name="year" id="year" lay-verify="required" autocomplete="off"
                                       class="layui-input" placeholder="请输入文献年份">
                            </div>
                            <div class="layui-input-inline" style="margin-left: 100px">
                                <button class="layui-btn" lay-submit="" lay-filter="submit">提交</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

</div>
<script src="./static/plug/layui/layui.js" charset="utf-8"></script>
<script src='./static/js/jquery/jquery.min.js'></script>
<script>
    var attachment = "";

    $(function () {
       var docId = window.localStorage.getItem('docId');
       console.log("docId = " + docId);
       if(docId > 0){
           $("#op-document").text("修改文献");
           $.ajax({
               type: 'post',
               url: "${ctx}/document/findDocById",
               data: {"id": docId},
               dataType: "json",
               success: function (data) {
                   if (data.code != 200) {
                       layer.msg(data.msg,{icon: 2});
                       return '';
                   } else {
                       var doc = data.data.document;
                       var name = doc.name;
                       var author = doc.author;
                       var digest = doc.digest;
                       var keywords = doc.keywords;
                       var topic = doc.topic;
                       var note = doc.note;
                       var auth = doc.auth;
                       var year = doc.year;
                       attachment = doc.attachment;

                       console.log("name = " + name);

                       $("#name").val(name);
                       $("#author").val(author);
                       $("#digest").val(digest);
                       $("#keywords").val(keywords);
                       $("#topic").val(topic);
                       $("#note").val(note);
                       $("#year").val(year);
                       if(auth == 0){
                           $("#auth_0").attr("selected", "selected");
                       }else if(auth == 1){
                           $("#auth_1").attr("selected", "selected");
                       }else if(auth == 2){
                           $("#auth_2").attr("selected", "selected");
                       }else if(auth == 3){
                           $("#auth_3").attr("selected", "selected");
                       }
                       docId = 0;
                   }
               }
           });
       }
        window.localStorage.removeItem('docId');
    });

    var editorId = "${user.id}";
    var level = "${user.level}";
    if (level == 0) {
        $("#auth_1").attr("disabled", "disabled");
        $("#auth_2").attr("disabled", "disabled");
        $("#auth_3").attr("disabled", "disabled");
    } else if (level == 1) {
        $("#auth_2").attr("disabled", "disabled");
        $("#auth_3").attr("disabled", "disabled");
    } else if (level == 2) {
        $("#auth_3").attr("disabled", "disabled");
    } else if (level == -1) {
        $("#auth_0").attr("disabled", "disabled");
        $("#auth_1").attr("disabled", "disabled");
        $("#auth_2").attr("disabled", "disabled");
        $("#auth_3").attr("disabled", "disabled");
    }

    $(function () {
        getAffiliationParent();
    });

    function getAffiliationParent() {
        $.ajax({
            type: 'POST',
            url: '${ctx}/affiliation/showFirstLayer',
            dataType: 'json',
            success: function (data) {
                if (data.code != 200) {
                    layer.msg(data.msg, {icon: 2});
                    return false;
                } else {
                    var affiliationList = data.data.affiliationList;
                    var html = '<option value="">请选择</option>';
                    affiliationList.forEach(function (element) {
                        var name = element.name;
                        var id = element.id;
                        if (element.deleted == 1 && element.parentId == 0) {
                            html = html + '<option value="' + id + '">' + name + '</option>';
                        }
                    });
                    $("#affiliation_1").html(html);
                }
            }
        });
    }

    layui.use(['form', 'layedit', 'upload'], function () {
        var form = layui.form;
        var $ = layui.jquery;
        var layer = layui.layer;
        var upload = layui.upload;

        //选完文件后不自动上传
        upload.render({
            elem: '#test8',
            url: '${ctx}/document/upload',
            auto: false,
            method: 'POST',
            accept: 'file',
            bindAction: '#test9',

            before: function (obj) {
                layer.load();
            },
            done: function (res) {
                layer.closeAll('loading');
                if (res.code != 200) {
                    layer.msg(res.msg, {icon: 2});
                    return false;
                } else {
                    layer.msg("文件上传成功", {icon: 6});
                    attachment = res.data.attachment;
                    console.log(attachment);
                    return false;
                }
            }
        });

        //自定义验证规则
        form.verify({});

        $(function () {
            getAffiliationParent();
        });

        function getAffiliationParent() {
            $.ajax({
                type: 'POST',
                url: '/affiliation/showFirstLayer',
                dataType: 'json',
                success: function (data) {
                    if (data.code != 200) {
                        layer.msg(data.msg, {icon: 2});
                        return false;
                    } else {
                        var affiliationList = data.data.affiliationList;
                        var html = '<option value="">请选择</option>';
                        affiliationList.forEach(function (element) {
                            var name = element.name;
                            var id = element.id;
                            if (element.deleted == 1 && element.parentId == 0) {
                                html = html + '<option value="' + id + '">' + name + '</option>';
                            }
                        });
                        console.log("html_1 = " + html);
                        $("#affiliation_1").html(html);
                        form.render('select');
                    }
                }
            });
        }

        //监听指定开关
        form.on('select(affiliation-parent)', function (data) {
            $.ajax({
                type: 'POST',
                url: '${ctx}/affiliation/showNextLayer',
                data: {"parentId": data.value},
                dataType: 'json',
                success: function (result) {
                    if (result.code != 200) {
                        layer.msg(result.msg, {icon: 2});
                        return false;
                    } else {
                        var childrenList = result.data.childrenList;
                        var html = '<option value="">请选择</option>';
                        childrenList.forEach(function (element) {
                            var name = element.name;
                            var id = element.id;
                            if (element.deleted == 1) {
                                html = html + '<option value="' + id + '">' + name + '</option>';
                            }
                        });
                        console.log("html_2 = " + html);
                        $("#affiliation_2").html(html);
                        form.render('select');
                    }
                }
            });
        });

        //监听提交
        form.on('submit(submit)', function (data) {

            console.log("attachment = " + attachment);
            if (attachment =="") {
                layer.msg("请选择您要上传的文献", {icon: 2});
                return false;
            }
            if(editorId == null || editorId == ""){
                layer.msg("请您登录", {icon: 2});
                return false;
            }
            var name = $("#name").val();  // 文献名称
            var author = $("#author").val(); // 文献作者
            var digest = $("#digest").val();  // 文献摘要
            var keywords = $("#keywords").val();  // 文献关键字
            var topic = $("#topic").val();  // 文献主题
            var affiliation_1 = $("#affiliation_1").val();  // 文献一级附属id
            var affiliation_2 = $("#affiliation_2").val();  // 文献二级附属id
            var affiliationId = affiliation_2;
            if(affiliation_1 == ""){
                layer.msg("请选择文件归属", {icon: 2});
                return false;
            }else if(affiliation_2 == ""){
                affiliationId = affiliation_1;
            }
            var note = $("#note").val();  // 文献备注
            var auth = $("#auth").val();  // 文献密级
            var year = $("#year").val();  // 文献年份

            $.ajax({
                type: 'POST',
                url: '${ctx}/document/insert',
                data: {
                    "name": name,
                    "keywords": keywords,
                    "digest": digest,
                    "topic": topic,
                    "affiliationId": affiliationId,
                    "year": year,
                    "note": note,
                    "attachment": attachment,
                    "editorId": editorId,
                    "auth": auth,
                    "author": author,
                },
                dataType: 'json',
                success: function (result) {
                    if (result.code != 200) {
                        layer.msg(result.msg, {icon: 2});
                        return false;
                    } else {
                        layer.msg("文献新增成功，即将跳转主页！", {icon: 6});
                        setTimeout('window.location.href = "${ctx}/"', 3000);
                    }
                }
            });
            return false;
        });
    });
</script>
</body>
</html>