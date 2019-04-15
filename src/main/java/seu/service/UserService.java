package seu.service;

import org.apache.commons.lang3.StringUtils;

import org.aspectj.apache.bcel.classfile.Code;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import seu.base.CodeEnum;

import seu.dao.LoginTicketDAO;
import seu.dao.UserDAO;
import seu.exceptions.COIPIBException;
import seu.model.LoginTicket;
import seu.model.User;
import seu.util.COIPIBUtil;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class UserService {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private LoginTicketDAO loginTicketDAO;

    public String register(User user) throws COIPIBException {
        checkBeforeRegister(user);

        userDAO.persist(user);

        return addLoginTicket(user.getId());

    }

    public String login(User user, String validationCode, String oldValidationCode) throws COIPIBException {
        checkBeforeLogin(user, validationCode, oldValidationCode);

        User old = userDAO.selectByName(user.getName());
        if (!StringUtils.equals(old.getPassword(), user.getPassword())) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "密码错误！");
        }
        if (old.getActive() == 1) {
            throw new COIPIBException(CodeEnum.USER_INACTIVE_ERROR, "该账号尚未激活！");
        }

        return addLoginTicket(old.getId());
    }

    private void checkBeforeRegister(User user) throws COIPIBException{
        if (StringUtils.isBlank(user.getName())) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "用户名不能为空！");
        }
        if (StringUtils.isBlank(user.getPassword())) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "密码不能为空！");
        }
        if (StringUtils.isBlank(user.getEmail()) || !EmailService.isMail(user.getEmail())) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "邮箱不合法！");
        }

        User old = userDAO.selectByName(user.getName());
        if (old != null) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "用户名已存在！");
        }

    }

    private void checkBeforeLogin(User user, String validationCode, String oldValidationCode) throws COIPIBException {
        if (!StringUtils.equals(validationCode, oldValidationCode)) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "验证码输入错误！");
        }
        if (StringUtils.isBlank(user.getName())) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "用户名不能为空！");
        }
        if (StringUtils.isBlank(user.getPassword())) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "密码不能为空！");
        }
        if (StringUtils.isBlank(validationCode)) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "验证码不能为空！");
        }
        User old = userDAO.selectByName(user.getName());
        if (old == null) {
            throw new COIPIBException(CodeEnum.USER_ERROR, "用户不存在！");
        }
    }

    private String addLoginTicket(int userId) {
        LoginTicket ticket = new LoginTicket();
        ticket.setUserId(userId);
        Date date = new Date();
        // 一天过期
        date.setTime(date.getTime() + 3600*24*1000);
        ticket.setExpireTime(new Timestamp(date.getTime()));
        ticket.setStatus(0);
        ticket.setTicket(UUID.randomUUID().toString().replaceAll("-", ""));
        loginTicketDAO.persist(ticket);
        return ticket.getTicket();
    }

    public void logout(String ticket) {
        loginTicketDAO.updateStatus(ticket,1);
    }

    public void active(String ticket) throws COIPIBException{
        if (StringUtils.isBlank(ticket)) {
            throw new COIPIBException(CodeEnum.USER_INACTIVE_ERROR, "ticket不能为空！");
        }
        LoginTicket loginTicket = loginTicketDAO.selectByTicket(ticket);
        if (loginTicket != null && loginTicket.getExpireTime().after(new Date())
                    && loginTicket.getStatus() == 0 && loginTicket.getUserId() != null) {
            User user = userDAO.selectById(loginTicket.getUserId());
            if (user != null) {
                user.setActive(0);
                userDAO.update(user);
            }
        } else {
            throw new COIPIBException(CodeEnum.USER_INACTIVE_ERROR, "该激活邮件已失效！");
        }


    }

    public Map<String, Object> buildActiveEmail(String email, String ticket, HttpServletRequest request) {
        Map<String, Object> map = new HashMap<>();
        map.put("to", email);
        map.put("subject", "COIPIB-账号激活");
        String text = "<html><p><h3>这是一封激活邮件</h3></p><p><h3><a href="
                + COIPIBUtil.getAPPURL(request) + "active/?ticket=" + ticket +">点击这里激活您的账号</a> 【24小时内有效】" + "</h3></p></html>";
        map.put("text", text);
        return map;
    }

}
