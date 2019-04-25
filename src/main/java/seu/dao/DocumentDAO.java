package seu.dao;

import org.apache.ibatis.annotations.*;
import seu.model.Document;
import seu.model.User;

import java.util.List;

@Mapper
public interface DocumentDAO {

    String TABLE_NAME = " document ";

    public Integer insert(Document document);

    public Integer update(Document document);

    @Delete({"delete from", TABLE_NAME, "where id=#{id}"})
    public Integer delete(@Param("id") Integer id);

    public List<Document> selectByAffiliationId(@Param("affiliationId") Integer affiliationId,
                                                @Param("user")User user,
                                                @Param("isEdit") Boolean isEdit,
                                                @Param("isActive") Boolean isActive);

    @Select({"select * from", TABLE_NAME, "where id = #{id}"})
    public Document selectById(Integer id);

    @Select({"select * from", TABLE_NAME, "where name like '%${name}%' limit #{begin}, #{end}"})
    public List<Document> simpleSearch(@Param("name") String name, @Param("begin")Integer begin, @Param("end")Integer end);

    @Select({"select count(id) from", TABLE_NAME, "where name like '%${name}%'"})
    public Integer countSimpleSearch(@Param("name") String name);

    /**
     * @TODO 特殊查询
     * */
}
