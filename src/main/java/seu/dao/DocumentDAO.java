package seu.dao;

import org.apache.ibatis.annotations.*;
import seu.model.Document;
import seu.model.User;

import java.util.List;

@Mapper
public interface DocumentDAO {

    String TABLE_NAME = " document ";

    public Integer insert(Document document);

    public Integer updateDocument(Document document);

    @Delete({"delete from", TABLE_NAME, "where id=#{id}"})
    public Integer deleteDocument(@Param("id") Integer id);

    public List<Document> selectByAffiliationId(Integer affiliationId, User user);

    @Select({"select * from", TABLE_NAME, "where id = #{id}"})
    public Document selectById(Integer id);

    /**
     * @TODO 特殊查询
     * */
}
