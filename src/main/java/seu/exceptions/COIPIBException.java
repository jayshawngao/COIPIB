package seu.exceptions;

import seu.base.CodeEnum;

public class COIPIBException extends Exception{

    CodeEnum codeEnum;

    public CodeEnum getCodeEnum() {
        return codeEnum;
    }

    public void setCodeEnum(CodeEnum codeEnum) {
        this.codeEnum = codeEnum;
    }

    public COIPIBException() {
    }

    public COIPIBException(CodeEnum codeEnum, String msg) {
        super(msg);
        this.codeEnum = codeEnum;
    }
}
