layui.use(['element', 'jquery', 'form', 'layedit'], function () {
    var element = layui.element;
    var form = layui.form;
    var $ = layui.jquery;
    var layedit = layui.layedit;

    //评论和留言的编辑器
    var editIndex = layedit.build('remarkEditor', {
        height: 100,
        tool: ['face', '|', 'strong', '|', 'italic', '|', 'underline', '|', 'link']
    });
    //评论和留言的编辑器的验证
    layui.form.verify({
        content: function (value) {
            value = $.trim(layedit.getText(editIndex));
            if (value == "") return "至少得有一个字吧";
            layedit.sync(editIndex);
        }
    });

    //Hash地址的定位
    var layid = location.hash.replace(/^#tabIndex=/, '');
    if (layid == "") {
        element.tabChange('tabAbout', 1);
    }
    element.tabChange('tabAbout', layid);

    element.on('tab(tabAbout)', function (elem) {
        location.hash = 'tabIndex=' + $(this).attr('lay-id');
    });

    //监听留言提交
    form.on('submit(formRemark)', function (data) {
        var index = layer.load(1);
        var content = data.field.content;
        var aId = data.field.aId;
        var id = data.field.id;
        var time = getNowFormatDate();
        $.ajax({
            url: '/submitComment',
            data: {'content': content, 'aId': aId, 'id': id},
            dataType: 'json',
            success: function (data) {
                var message = data['message'];
                layer.close(index);
                if (message === 'fail') {
                    layer.msg("评论也要先登录一下吧", {icon: 1});
                } else {
                    var html = '<li><div class="comment-parent"><img src="../images/Logo_40.png"alt="留言"/><div class="info"><span class="username">' + message + '</span></div><div class="content">' + content + '</div><p class="info info-footer"><span class="time">' + time + '</span><a class="btn-reply"href="javascript:;" onclick="btnReplyClick(this)">回复</a></p></div><!--回复表单默认隐藏--><div class="replycontainer layui-hide"><form class="layui-form"action=""><div class="layui-form-item"><textarea name="replyContent"lay-verify="replyContent"placeholder="请输入回复内容"class="layui-textarea"style="min-height:80px;"></textarea></div><div class="layui-form-item"><button class="layui-btn layui-btn-mini"lay-submit="formReply"lay-filter="formReply">提交</button></div></form></div></li>';
                    $('.blog-comment').append(html);
                    $('#remarkEditor').val('');
                    editIndex = layui.layedit.build('remarkEditor', {
                        height: 100,
                        tool: ['face', '|', 'strong', '|', 'italic', '|', 'underline', '|', 'link'],
                    });
                    layer.msg("评论成功", {icon: 1});
                }
            }
        });
        return false;
    });

    //监听留言回复提交
    form.on('submit(formReply)', function (data) {
        var index = layer.load(1);
        var articleId = data.field.articleId;
        var cId = data.field.cId;
        var byId = data.field.byId;
        var content = data.field.replyContent;
        console.log("articleId = " + articleId + " cId = " + cId + " byId = " + byId + " content = " + content);
        $.ajax({
            url: '/submitChildComment',
            data: {'articleId': articleId, 'cId': cId, 'byId': byId, 'content': content},
            dataType: 'json',
            success: function (data) {
                var message = data['message'];
                layer.close(index);
                setTimeout(function () {
                    if (message === 'fail') {
                        layer.msg("回复人家也要先登录一下吧", {icon: 1});
                    } else {
                        layer.msg("回复成功", { icon: 1 });
                        location.reload();
                    }
                }, 500);
            }
        });
        return false;
    });
});

function btnReplyClick(elem) {
    var $ = layui.jquery;
    $(elem).parent('p').parent('.comment-parent').siblings('.replycontainer').toggleClass('layui-hide');
    if ($(elem).text() == '回复') {
        $(elem).text('收起')
    } else {
        $(elem).text('回复')
    }
}

function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
        + " " + date.getHours() + seperator2 + date.getMinutes()
        + seperator2 + date.getSeconds();
    return currentdate;
}