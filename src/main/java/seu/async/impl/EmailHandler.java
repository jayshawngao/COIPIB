package seu.async.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import seu.async.EventHandler;
import seu.async.EventModel;
import seu.async.EventType;
import seu.exceptions.COIPIBException;
import seu.service.EmailService;


@Component
public class EmailHandler implements EventHandler {
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailHandler.class);
    @Autowired
    private EmailService emailService;

    @Override
    public void doHandle(EventModel model) {
        try {
            emailService.sendEmail(model.getMap());
        } catch (Exception e) {
            LOGGER.error("邮件发送失败，parameter:map={}", model.getMap(), e);
        }
    }

    @Override
    public EventType belongTo() {
        return EventType.EMAIL;
    }
}
