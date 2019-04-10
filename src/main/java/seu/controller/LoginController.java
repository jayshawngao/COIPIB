package seu.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import seu.async.EventConsumer;
import seu.async.EventModel;
import seu.async.EventType;
import seu.base.CodeEnum;
import seu.base.CommonResponse;
import seu.exceptions.COIPIBException;
import seu.model.User;
import seu.service.EmailService;
import seu.service.UserService;


import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

@Controller
public class LoginController {
    private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);

    @Autowired
    UserService userService;

    @Autowired
    EmailService emailService;

    @Autowired
    EventConsumer eventConsumer;

    @ResponseBody
    @RequestMapping("/register")
    public String register(User user, HttpServletRequest request) {
        try {
            String ticket = userService.register(user);
            EventModel eventModel = new EventModel(EventType.EMAIL,
                    userService.buildActiveEmail(user.getEmail(), ticket, request));
            eventConsumer.submit(eventModel);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "注册成功").toJSONString();
        } catch (COIPIBException e) {
            LOGGER.info("注册失败", e);
            return new CommonResponse(e.getCodeEnum().getCode(), e.getMessage()).toJSONString();
        } catch (Exception e) {
            LOGGER.info("未知错误", e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getCode(), e.getMessage()).toJSONString();
        }
    }

    @ResponseBody
    @RequestMapping("/login")
    public String login(User user, HttpServletResponse response) {
        try {
            String ticket = userService.login(user);
            addCookie(ticket, response);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "登录成功").toJSONString();
        } catch (COIPIBException e) {
            LOGGER.info("登录失败", e);
            return new CommonResponse(e.getCodeEnum().getCode(), e.getMessage()).toJSONString();
        } catch (Exception e) {
            LOGGER.info("未知错误", e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getCode(), e.getMessage()).toJSONString();
        }

    }

    private void addCookie(String ticket, HttpServletResponse response) {
        Cookie cookie = new Cookie("ticket", ticket);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    @ResponseBody
    @RequestMapping("/logout")
    public String logout(@CookieValue("ticket") String ticket) {
        try {
            userService.logout(ticket);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "退出成功").toJSONString();
        } catch (Exception e) {
            LOGGER.info("未知错误", e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getCode(), e.getMessage()).toJSONString();
        }
    }

    @ResponseBody
    @RequestMapping("/active")
    public String active(String ticket) {
        try {
            userService.active(ticket);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "激活成功").toJSONString();
        } catch (COIPIBException e) {
            LOGGER.info("激活失败", e);
            return new CommonResponse(e.getCodeEnum().getCode(), e.getMessage()).toJSONString();
        } catch (Exception e) {
            LOGGER.info("未知错误", e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getCode(), e.getMessage()).toJSONString();
        }
    }

}
