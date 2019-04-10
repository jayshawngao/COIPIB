layui.use(['form', 'jquery', 'layer'], function () {
    var form = layui.form;
    var $ = layui.jquery;
    var layer = layui.layer;

    form.verify({
        title: function () {
            var title = $("#title").val();
            title = $.trim(title);
            console.log("title = " + title);
            if (title === "") {
                return "标题不能为空";
            }
        },

        editor: function () {
            var editor = $("#editor").val();
            if ($.trim(editor) === "" && editor.size() <= 0) {
                return "文章内容不能为空";
            }
        },

        modules: function () {
            var modules = $("#modules").val();
            var category = $("#category").val();
            if ($.trim(modules) === "" && $.trim(category) === "") {
                return "文章类型不能为空";
            }
        }
    });

    // 监听提交
    form.on('submit(submitBlog)', function () {
        var aId = $(".hiddenAId").val();
        var title = $("#title").val();
        var editor = $('#editor').val();
        var modules = $('#modules').val();
        var category = $('#category').val();
        var open = $('#open').val();
        $.ajax({
            type: 'post',
            url: '/doWrite',
            data: {"aId":aId, "title": title, "editor": editor, "modules": modules, "category": category, "open": open},
            dataType: 'json',
            async: false,
            success: function (data) {
                var message = data['message'];

                if(message === "addSuccess"){
                    console.log("文章创建成功");
                    active.notice();
                }else if(message === "modifySuccess"){
                    console.log("文章修改成功");
                    active.notice();
                }
            }
        });
        return false;
    });

    var active = {
        notice: function () {
            layer.open({
                type: 1,
                title: false, //不显示标题栏
                closeBtn: false,
                area: '300px;',
                shade: 0.8,
                id: 'LAY_layuipro', //设定一个id，防止重复弹出
                btn: ['再写一篇', '返回主页'],
                btnAlign: 'c',
                moveType: 1, //拖拽模式，0或者1
                content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">恭喜，文章发布成功啦！！！<br><br></div>'
                , success: function (layero) {
                    var btn = layero.find('.layui-layer-btn');
                    btn.find('.layui-layer-btn0').attr({
                        href: '/write',
                        target: '_self'
                    });
                    btn.find('.layui-layer-btn1').attr({
                        href: '/home',
                        target: '_self'
                    });
                }
            });
        }
    };

    form.on('submit(saveDrift)', function (data) {
        return false;
    });

});

