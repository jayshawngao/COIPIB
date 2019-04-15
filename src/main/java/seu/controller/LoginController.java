package seu.controller;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import seu.async.EventConsumer;
import seu.async.EventModel;
import seu.async.EventType;
import seu.base.CodeEnum;
import seu.base.CommonResponse;
import seu.exceptions.COIPIBException;
import seu.model.User;
import seu.service.CodeCaptchaService;
import seu.service.EmailService;
import seu.service.UserService;


import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;

@Controller
public class LoginController {
    private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);

    @Autowired
    UserService userService;

    @Autowired
    EmailService emailService;

    @Autowired
    EventConsumer eventConsumer;

    @Autowired
    CodeCaptchaService codeCaptchaService;

    @ResponseBody
    @RequestMapping("/register")
    public String register(User user, HttpServletRequest request) {
        try {
            user.setName(user.getName().trim());
            user.setEmail(user.getEmail().trim());
            String ticket = userService.register(user);
            EventModel eventModel = new EventModel(EventType.EMAIL,
                    userService.buildActiveEmail(user.getEmail(), ticket, request));
            eventConsumer.submit(eventModel);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "注册成功").toJSONString();
        } catch (COIPIBException e) {
            LOGGER.info(e.getMessage() + " parameter:user={}", user);
            return new CommonResponse(e.getCodeEnum().getCode(), e.getMessage()).toJSONString();
        } catch (Exception e) {
            LOGGER.error("/register parameter:user={}", user, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getCode(), e.getMessage()).toJSONString();
        }
    }

    @ResponseBody
    @RequestMapping("/login")
    public String login(User user, String validationCode, HttpServletRequest request, HttpServletResponse response) {
        try {
             String oldValidationCode = (String)request.getSession().getAttribute("validationCode");
            String ticket = userService.login(user, validationCode, oldValidationCode);
            addCookie(ticket, response);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "登录成功").toJSONString();
        } catch (COIPIBException e) {
            LOGGER.info(e.getMessage() + " parameter:user={}, validationCode={}, oldValidationCode={}", user, validationCode,
                    request.getSession().getAttribute("validationCode"));
            return new CommonResponse(e.getCodeEnum().getCode(), e.getMessage()).toJSONString();
        } catch (Exception e) {
            LOGGER.error("/login parameter:user={}, validationCode={}, oldValidationCode={}", user, validationCode,
                    request.getSession().getAttribute("validationCode"), e);
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
            LOGGER.info("/logout parameter:ticket={}", ticket, e);
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
            LOGGER.info(e.getMessage() + " parameter:ticket={}", ticket);
            return new CommonResponse(e.getCodeEnum().getCode(), e.getMessage()).toJSONString();
        } catch (Exception e) {
            LOGGER.error("/active parameter:ticket={}", ticket, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getCode(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/codeCaptcha")
    @ResponseBody
    public String codeCaptcha(HttpServletRequest request) {
        try {
            request.getSession().removeAttribute("validationCode");
            String validationCode = codeCaptchaService.genValidationCode();
            request.getSession().setAttribute("validationCode", validationCode);
            String image = codeCaptchaService.getImageString(validationCode);
            HashMap<String, Object> data = new HashMap<>();
            data.put("image", image);
            return new CommonResponse(CodeEnum.SUCCESS.getCode(), "验证码生成成功", data).toJSONString();
        } catch (Exception e) {
            LOGGER.error("/codeCaptcha", e);
            return new CommonResponse(CodeEnum.USER_ERROR.getCode(), e.getMessage()).toJSONString();
        }
    }
}
