package seu.dao;

import org.apache.ibatis.annotations.*;
import seu.model.Document;

import java.util.List;

@Mapper
public interface DocumentDAO {

    String TABLE_NAME = " document ";

    public Integer insert(Document document);

    public Integer updateDocument(Document document);

    @Update({"update", TABLE_NAME, "set deleted=0 where id = #{id}"})
    public Integer moveDocumentIntoBin(@Param("id") Integer id);

    @Select({"select * from", TABLE_NAME, "where deleted=0"})
    public List<Document> showAllDocumentInBin();

    @Delete({"delete from", TABLE_NAME, "where id=#{id}"})
    public Integer deleteDocument(@Param("id") Integer id);

    @Delete({"delete from", TABLE_NAME, "where deleted=0"})
    public Integer clearBin();

    @Select({"select * from", TABLE_NAME, "where deleted=1"})
    public List<Document> showAllDocumentNotDeleted();

    /**
     * @TODO 特殊查询
     * */
}
