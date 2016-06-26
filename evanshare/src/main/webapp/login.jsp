<!doctype html>
<html class="signin no-js" lang="$!app_language">
<head>

    <meta charset="utf-8">
    <meta name="description" content="Flat, Clean, Responsive, application admin template built with bootstrap 3">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1">
    <meta name="description" content="${app_name}">
    <meta name="keywords" content="nutz,wizzer">
    <title>${app_name}</title>
    <link rel="stylesheet" href="${base}/include/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${base}/include/css/font-awesome.css">
    <link rel="stylesheet" href="${base}/include/css/themify-icons.css">
    <link rel="stylesheet" href="${base}/include/css/animate.min.css">
    <link rel="stylesheet" href="${base}/include/css/skins/palette.css">
    <link rel="stylesheet" href="${base}/include/css/fonts/font.css">
    <link rel="stylesheet" href="${base}/include/css/main.css">
    <!--[if lt IE 9]>
    <script src="${base}/include/js/html5shiv.js"></script>
    <script src="${base}/include/js/respond.min.js"></script>
    <script src="${base}/include/js/json2.js"></script>
    <![endif]-->
    <script src="${base}/include/plugins/modernizr.js"></script>
    <script src="${base}/include/plugins/jquery-1.11.1.min.js"></script>
    <script src="${base}/include/js/jquery.pjax.js"></script>

</head>
<body class="">
<div class="overlay"></div>
<div class="center-wrapper">
    <div class="center-content">
        <div class="row no-m">
            <div class="col-xs-10 col-xs-offset-1 col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4">
                <section class="panel bg-white no-b fadeIn animated">
                    <header class="panel-heading no-b text-center" style="font-size:30px;">
                        ${app_name}
                    </header>
                    <!-- START Language list-->
                    <ul class="nav navbar-nav navbar-right">
                        <li class="language-dropdown dropdown hidden-xs">
                            <a href="javascript:;" data-toggle="dropdown" id="language">
                                #if(!$app_language||$app_language=="zh_CN")
                                <img src="${base}/include/img/flags/cn.png" class="flag">
                                <span class="language">中文</span>
                                #else
                                <img src="${base}/include/img/flags/us.png" class="flag">
                                <span class="language">US</span>
                                #end
                            </a>
                            <ul class="dropdown-menu dropdown-menu-right animated fadeInUp">
                                <li>
                                    <a href="${base}/private/language/en_US">
                                        <img src="${base}/include/img/flags/us.png" class="flag">
                                        <span class="language">English</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="${base}/private/language/zh_CN">
                                        <img src="${base}/include/img/flags/cn.png" class="flag">
                                        <span class="language">中文</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                    <!-- END Language list    -->
                    <div class="p15">
                        <form id="loginForm" action="${base}/private/doLogin" data-parsley-validate="" novalidate="" role="form" method="post">
                            <input type="hidden" id="captcha" name="captcha">

                            <div class="form-group">
                                <input type="text" id="username" name="username" value="superadmin" required class="form-control input-lg mb25"
                                       placeholder="${msg['login.username']}">
                            </div>
                            <div class="form-group">
                                <input type="password" id="password" name="password" value="1" required class="form-control input-lg mb25"
                                       placeholder="${msg['login.password']}">
                            </div>
                            <p id="tip" class="bg-danger p15" style="display:none"></p>

                            <div class="show">
                                <div class="pull-right">
                                    <a href="#">${msg['login.foget']}</a>
                                </div>
                                <label class="checkbox">
                                    <input id="remember" type="checkbox" value="remember-me">${msg['login.rememberme']} </label>
                            </div>
                            <button class="btn btn-primary btn-lg btn-block" type="submit" data-loading-text="${msg['login.submit']}">
                                ${msg['login.submit']}
                            </button>
                        </form>
                    </div>
                </section>
                <p class="text-center text-default">
                    Copyright &copy;
                    <span id="year" class="mr5"></span>
                    <span>${app_copyright}</span>
                </p>
            </div>
        </div>

    </div>
</div>
<!-- 验证码 -->
<div id="dialogVeryCode" class="modal fade bs-modal-sm" tabindex="-3" role="dialog" aria-hidden="false">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" style="color:black;">${msg['login.error.ip']}
                </h4>
            </div>
            <div class="modal-body">
                <form id="f2" onsubmit="return false;" data-parsley-validate="" novalidate="">
                    <div class="row">
                        <div class="col-xs-2"></div>
                        <div class="col-xs-6">
                            <input type="text" id="verifycode" required class="form-control input-lg" placeholder="${msg['login.captcha']}">
                        </div>
                        <div class="col-xs-4">
                            <img id="captcha_img" src="${base}/captcha/next" style="height:46px;cursor: pointer;" onclick="$('#captcha_img').attr('src', '${base}/captcha/next?_=' + new Date().getTime())"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="ok" type="button" class="btn btn-primary" data-dismiss="modal">${msg['login.submit']}
                </button>
            </div>
        </div>
    </div>
</div>
<script src="${base}/include/plugins/jquery.form.js"></script>
<script src="${base}/include/bootstrap/js/bootstrap.js"></script>
<script src="${base}/include/plugins/parsley.min.js"></script>
#if(!$app_language||$app_language=="zh_CN")
<script src="${base}/include/plugins/parsley.zh_cn.js"></script>
#end
<script type="text/javascript">
    $(document).ready(function () {
        var langOpen = true;
        $("#language").on("click",function () {
            if (!langOpen) {
                $('.language-dropdown').addClass('open');
                langOpen = true;
            } else {
                $('.language-dropdown').removeClass('open');
                langOpen = false;
            }
        });
        $("#year").html(new Date().getFullYear());
        $("#loginForm").ajaxForm({
            dataType:  'json',
            beforeSubmit:function(arr, form, options){
                form.find("button:submit").text("${msg['login.load']}");
                form.find("button:submit").attr("disabled", "disabled");
            },
            success : function(data, statusText, xhr, form) {
                if(data.type == "success"){
                    $("#tip").hide();
                    form.find("button:submit").text("${msg['login.submit']}");
                    window.location.href = "${base}/private/index";
                }else if(data.type == "iperror"){
                    $("#verifycode").val("");
                    $("#dialogVeryCode img").attr("src", '${base}/captcha/next?_=' + new Date().getTime());
                    return $("#dialogVeryCode").modal({show: true,backdrop: 'static', keyboard: false});
                }else{
                    $("#captcha").val("");
                    $('#captcha_img').attr('src', '${base}/captcha/next?_=' + new Date().getTime());
                    $("#tip").html(data.content);
                    $("#tip").fadeIn();
                    form.find("button:submit").text("${msg['login.submit']}");
                    form.find("button:submit").removeAttr("disabled")
                }
            }
        });
        $("#ok").on("click",function () {
            if($("#verifycode").val()==""){
                $("#f2").submit();
                return false;
            }
            $("#captcha").val($("#verifycode").val());
            $("#loginForm").submit();
        });
        $("#dialogVeryCode").on("keypress",function (event) {
            var key = event.which;
            if (key == 13) {
                $("#ok").trigger("click");
            }
        });
        $("#username").focus();
    });
</script>
</body>
</html>
