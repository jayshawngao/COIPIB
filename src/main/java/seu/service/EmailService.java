package seu.service;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import seu.base.CodeEnum;
import seu.exceptions.COIPIBException;
import seu.util.COIPIBUtil;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Service
public class EmailService implements InitializingBean {
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailService.class);

    @Value("${email.host}")
    private String host;
    @Value("${email.username}")
    private String username;
    @Value("${email.password}")
    private String password;
    @Value("${email.from}")
    private String from;

    private JavaMailSenderImpl mailSender;
    private static String regex = "^[a-zA-Z0-9][a-zA-Z0-9_\\.]+[a-zA-Z0-9]@[a-z0-9]{2,7}(\\.[a-z]{2,3}){1,3}$";
    private static Pattern pattern = Pattern.compile(regex);
    
    public static boolean isMail(String s){
    	Matcher matcher = pattern.matcher(s);
    	return matcher.matches();
    }
    
    public boolean sendEmail(String to, String ticket, HttpServletRequest request) throws COIPIBException, MessagingException {
        checkBeforeSendEmail(to, ticket, request);
        String html = "<html><p><h3>这是一封激活邮件</h3></p><p><h3><a href="
                + COIPIBUtil.getAPPURL(request) + "active/?ticket=" + ticket +">点击链接激活</a>" + "</h3></p></html>";
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
        helper.setFrom(from);
        helper.setTo(to);
        helper.setSubject("COIPIB-账户激活");
        helper.setText(html,true);
        mailSender.send(message);
        return true;

    }

    private void checkBeforeSendEmail(String email, String ticket, HttpServletRequest request) throws COIPIBException{
        if (StringUtils.isBlank(email)) {
            throw new COIPIBException(CodeEnum.EMAIL_ERROR, "邮件地址为空！");
        }
        if (StringUtils.isBlank(ticket)) {
            throw new COIPIBException(CodeEnum.EMAIL_ERROR, "ticket为空！");
        }
        if (request == null) {
            throw new COIPIBException(CodeEnum.EMAIL_ERROR, "request为空！");
        }
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        mailSender = new JavaMailSenderImpl();
        mailSender.setUsername(username);
        mailSender.setPassword(password);
        mailSender.setHost(host);
        Properties properties = new Properties();
        properties.setProperty("mail.host", "smtp.qq.com");
        properties.setProperty("mail.transport.protocol", "smtp");
        properties.setProperty("mail.smtp.auth", "true");
        properties.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        properties.setProperty("mail.smtp.port", "465");
        properties.setProperty("mail.smtp.socketFactory.port", "465");
        mailSender.setJavaMailProperties(properties);
    }
}
