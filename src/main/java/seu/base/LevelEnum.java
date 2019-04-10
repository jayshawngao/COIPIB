package seu.base;

public enum LevelEnum {

    VISITOR(0),

    MEMBER(1),

    VIP(2),

    ADMIN(3);

    int code;
    LevelEnum(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }
}
