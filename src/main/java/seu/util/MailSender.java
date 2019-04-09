package seu.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Service
public class MailSender implements InitializingBean {
    private static final Logger logger = LoggerFactory.getLogger(MailSender.class);
    private JavaMailSenderImpl mailSender;
    private static String regex = "^[a-zA-Z0-9][a-zA-Z0-9_\\.]+[a-zA-Z0-9]@[a-z0-9]{2,7}(\\.[a-z]{2,3}){1,3}$";
    private static Pattern pattern = Pattern.compile(regex);
    
    public static boolean isMail(String s){
    	Matcher matcher = pattern.matcher(s);
    	return matcher.matches();
    }
    
    public boolean sendEmail() {
        SimpleMailMessage message=new SimpleMailMessage();
        message.setFrom("");
        message.setTo("");
        message.setSubject("");
        String text = "";
        message.setText(text);
        mailSender.send(message);
        return true;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        mailSender = new JavaMailSenderImpl();
        mailSender.setUsername("jayshawn@qq.com");
        mailSender.setPassword("gylsuhfoqgpabbeb");
        mailSender.setHost("smtp.qq.com");
        Properties javaMailProperties = new Properties();  
        javaMailProperties.put("mail.smtp.auth", true);   
        javaMailProperties.put("mail.smtp.starttls.enable", true);   
        javaMailProperties.put("mail.smtp.timeout", 5000);   
        mailSender.setJavaMailProperties(javaMailProperties);  
    }
}
