package seu.exceptions;

import seu.base.CodeEnum;

public class COIPIBException extends Exception{

    CodeEnum codeEnum;
    String msg;

    public CodeEnum getCodeEnum() {
        return codeEnum;
    }

    public void setCodeEnum(CodeEnum codeEnum) {
        this.codeEnum = codeEnum;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public COIPIBException() {
    }

    public COIPIBException(CodeEnum codeEnum, String msg) {
        this.codeEnum = codeEnum;
        this.msg = msg;
    }
}
