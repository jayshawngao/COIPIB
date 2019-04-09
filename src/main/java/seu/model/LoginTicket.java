package seu.model;

import java.sql.Timestamp;

/**
 * 起到两个作用：记住已登录账号，作为激活邮件后缀
 */
public class LoginTicket {

    private Integer id;

    private Integer userId;

    private String ticket;

    private Timestamp expireTime;

    /**
     * 0 有效；1 无效
     */
    private Integer status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getTicket() {
        return ticket;
    }

    public void setTicket(String ticket) {
        this.ticket = ticket;
    }

    public Timestamp getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(Timestamp expireTime) {
        this.expireTime = expireTime;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LoginTicket() {
    }
}
