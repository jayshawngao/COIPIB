package seu.model;

import java.sql.Timestamp;
import java.util.List;

/**
 * 如果Document被逻辑删除，置affiliationId字段为200即可，不再使用字段deleted
 * author作者，editor是上传者
 */
public class Document {

    private Integer id;

    private String name;  // 文献标题

    private String author;

    // 逗号分隔多个关键词
    private String keywords;

    // 摘要 abstract是保留关键字
    private String digest;

    private String topic;  // 文献主题

    private Integer affiliationId;

    private List<Affiliation> affiliationList;

    private Integer year;

    private String note;

    private String attachment;

    private Integer editorId;

    private String editor;

    private Integer auth;

    /**
     * 0 激活；1 未激活
     */
    private Integer active;

    private Timestamp createTime;

    private Timestamp updateTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public String getDigest() {
        return digest;
    }

    public void setDigest(String digest) {
        this.digest = digest;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public Integer getAffiliationId() {
        return affiliationId;
    }

    public void setAffiliationId(Integer affiliationId) {
        this.affiliationId = affiliationId;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getAttachment() {
        return attachment;
    }

    public void setAttachment(String attachment) {
        this.attachment = attachment;
    }

    public Integer getEditorId() {
        return editorId;
    }

    public void setEditorId(Integer editorId) {
        this.editorId = editorId;
    }

    public String getEditor() {
        return editor;
    }

    public void setEditor(String editor) {
        this.editor = editor;
    }

    public Integer getAuth() {
        return auth;
    }

    public void setAuth(Integer auth) {
        this.auth = auth;
    }

    public Integer getActive() {
        return active;
    }

    public void setActive(Integer active) {
        this.active = active;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public Document() {
    }

    public List<Affiliation> getAffiliationList() {
        return affiliationList;
    }

    public void setAffiliationList(List<Affiliation> affiliationList) {
        this.affiliationList = affiliationList;
    }

    @Override
    public String toString() {
        return "Document{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", author='" + author + '\'' +
                ", keywords='" + keywords + '\'' +
                ", digest='" + digest + '\'' +
                ", topic='" + topic + '\'' +
                ", affiliationId=" + affiliationId +
                ", affiliationList=" + affiliationList +
                ", year=" + year +
                ", note='" + note + '\'' +
                ", attachment='" + attachment + '\'' +
                ", editorId=" + editorId +
                ", editor='" + editor + '\'' +
                ", auth=" + auth +
                ", active=" + active +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}
