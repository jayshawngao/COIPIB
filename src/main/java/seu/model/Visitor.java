package seu.model;

import org.springframework.stereotype.Component;
import seu.base.LevelEnum;

/**
 * 未登录用户
 */
@Component
public class Visitor extends User{
    public Visitor() {
        setId(-1);
        setLevel(LevelEnum.VISITOR.getValue());
    }
}