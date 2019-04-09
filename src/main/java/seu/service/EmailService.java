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

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.Map;
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
    
    public boolean sendEmail(Map<String, Object> map) throws Exception {
        checkBeforeSendEmail(map);

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
        helper.setFrom(from);
        helper.setTo((String)map.get("to"));
        helper.setSubject((String)map.get("subject"));
        helper.setText((String)map.get("text"),true);
        mailSender.send(message);
        return true;

    }

    private void checkBeforeSendEmail(Map<String, Object> map) throws COIPIBException{
        if (map == null) {
            throw new COIPIBException("邮件参数不能为空！");
        }
        if (StringUtils.isBlank((String)map.get("to"))) {
            throw new COIPIBException("邮件地址不能为空！");
        }
        if (StringUtils.isBlank((String)map.get("subject"))) {
            throw new COIPIBException("邮件名不能为空！");
        }
        if (StringUtils.isBlank((String)map.get("text"))) {
            throw new COIPIBException("邮件正文不能为空！");
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
