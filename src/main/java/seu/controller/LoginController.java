package seu.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import seu.base.CodeEnum;
import seu.base.CommonResponse;
import seu.exceptions.COIPIBException;
import seu.model.User;
import seu.service.UserService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

@Controller
public class LoginController {
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    @Autowired
    UserService userService;

    @ResponseBody
    @RequestMapping("/register")
    public String register(User user, Model model, HttpServletResponse response) {
        try {
            String ticket = userService.register(user);
            Cookie cookie = new Cookie("ticket", ticket);
            cookie.setPath("/");
            response.addCookie(cookie);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "注册成功").toJSONString();
        } catch (COIPIBException e) {
            logger.info("注册失败", e);
            return new CommonResponse(e.getCodeEnum().getCode(), e.getMessage()).toJSONString();
        }
    }

}
