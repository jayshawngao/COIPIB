package seu.base;

public enum CodeEnum {

    /**
     * OK
     */
    SUCCESS(200),

    /**
     * 数据库错误
     */
    DATABASE_ERROR(300),

    /**
     * 服务器错误
     */
    SERVER_ERROR(400),

    /**
     * 文件上传错误
     * */
    FILE_UPLOAD_ERROR(401),

    /**
     * 账户错误
     */
    USER_ERROR(500),

    /**
     * 文档相关错误
     */
    DOCUMENT_ERROR(600),

    /**
     * 未知错误
     */
    UNKNOWN_ERROR(1000);

    int value;
    CodeEnum(int value){
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
