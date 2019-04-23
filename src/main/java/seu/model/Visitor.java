package seu.model;

import org.springframework.stereotype.Component;
import seu.base.LevelEnum;

/**
 * 未登录用户
 */
@Component
public class Visitor extends User{
    public Visitor() {
        setLevel(LevelEnum.VISITOR.getValue());
    }
}