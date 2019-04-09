package seu.base;

public enum LevenEnum {

    VISITOR(0),

    MEMBER(1),

    VIP(2),

    ADMIN(3);

    int code;
    LevenEnum (int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }
}
