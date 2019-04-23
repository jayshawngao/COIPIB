package seu.model;

import java.sql.Timestamp;

public class Affiliation {

    /**
     * 100：未分类 200：回收站
     */
    private Integer id;

    private String name;

    private Integer parentId;

    /**
     * 0 删除；1 未删除
     */
    private Integer deleted;

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

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getDeleted() {
        return deleted;
    }

    public void setDelete(Integer delete) {
        this.deleted = deleted;
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

    public Affiliation() {
    }

    public Affiliation(Integer id, String name, Integer parentId, Integer deleted, Timestamp createTime, Timestamp updateTime) {
        this.id = id;
        this.name = name;
        this.parentId = parentId;
        this.deleted = deleted;
        this.createTime = createTime;
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "Affiliation{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", parentId=" + parentId +
                ", deleted=" + deleted +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}
