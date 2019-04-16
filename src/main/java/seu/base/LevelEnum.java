package seu.base;

public enum LevelEnum {

    VISITOR(0),

    MEMBER(1),

    VIP(2),

    ADMIN(3);

    int value;
    LevelEnum(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
