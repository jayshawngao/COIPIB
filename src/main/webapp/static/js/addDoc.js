var editorId = "${user.id}";
var level = "${user.level}";
console.log(level);
if(level == 0){
    $("#auth_1").attr("disabled", "disabled");
    $("#auth_2").attr("disabled", "disabled");
    $("#auth_3").attr("disabled", "disabled");
}else if(level == 1){
    $("#auth_2").attr("disabled", "disabled");
    $("#auth_3").attr("disabled", "disabled");
}else if(level == 2){
    $("#auth_3").attr("disabled", "disabled");
}else if(level == -1){
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
        url: '/affiliation/showFirstLayer',
        dataType: 'json',
        success: function (data) {
            if (data.code !== 200) {
                layer.msg(data.msg, {icon: 2});
                return false;
            } else {
                var affiliationList = data.data.affiliationList;
                var html = '<option value="">请选择</option>';
                affiliationList.forEach(function (element) {
                    var name = element.name;
                    var id = element.id;
                    if (element.deleted === 1 && element.parentId === 0) {
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

    var attachment = "";
    //选完文件后不自动上传
    upload.render({
        elem: '#test8',
        url: '/document/upload',
        auto: false,
        method: 'POST',
        accept: 'file',
        bindAction: '#test9',

        before: function (obj) {
            layer.load();
        },
        done: function (res) {
            layer.closeAll('loading');
            if (res.code !== 200) {
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

    //监听指定开关
    form.on('select(affiliation-parent)', function (data) {
        $.ajax({
            type: 'POST',
            url: '/affiliation/showNextLayer',
            data: {"parentId": data.value},
            dataType: 'json',
            success: function (result) {
                if (result.code !== 200) {
                    layer.msg(result.msg, {icon: 2});
                    return false;
                } else {
                    var childrenList = result.data.childrenList;
                    var html = '<option value="">请选择</option>';
                    childrenList.forEach(function (element) {
                        var name = element.name;
                        var id = element.id;
                        if (element.deleted === 1) {
                            html = html + '<option value="' + id + '">' + name + '</option>';
                        }
                    });
                    console.log(html);
                    $("#affiliation_2").html(html);
                    form.render('select');
                }
            }
        });
    });

    //监听提交
    form.on('submit(submit)', function (data) {
        if (attachment === "") {
            layer.msg("文件没能成功上传", {icon: 2});
        }
        var name = $("#name").val();  // 文献名称
        var author = $("#author").val(); // 文献作者
        var digest = $("#digest").val();  // 文献摘要
        var keywords = $("#keywords").val();  // 文献关键字
        var topic = $("#topic").val();  // 文献主题
        var affiliation_2 = $("#affiliation_2").val();  // 文献二级附属id
        var note = $("#note").val();  // 文献备注
        var auth = $("#auth").val();  // 文献密级
        var year = $("#year").val();  // 文献年份

        $.ajax({
            type: 'POST',
            url: '/document/insert',
            data: {
                "name": name,
                "keywords": keywords,
                "digest": digest,
                "topic": topic,
                "affiliationId": affiliation_2,
                "year": year,
                "note": note,
                "attachment": attachment,
                "editorId": editorId,
                "auth": auth,
                "author": author,
            },
            dataType: 'json',
            success: function (result) {
                if (result.code !== 200) {
                    layer.msg(result.msg, {icon: 2});
                    return false;
                } else {
                    layer.msg("文献新增成功，即将跳转主页！",{icon: 6});
                    setTimeout('window.location.href = "${ctx}/"', 3000);
                }
            }
        });
        return false;
    });
});