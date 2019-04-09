package seu.dao;

import org.apache.ibatis.annotations.*;
import seu.model.Affiliation;

import java.util.List;

@Mapper
public interface AffiliationDAO {
    String TABLE_NAME = " affiliation ";

    public int insert(Affiliation affiliation);

    @Update({"update", TABLE_NAME, "set deleted=0 where id=#{id};"})
    public int delete(@Param("id") Integer id);

    public int update(Affiliation affiliation);

    @Select({"select * from", TABLE_NAME, ";"})
    public List<Affiliation> selectAllAffiliation();

    @Select({"select * from", TABLE_NAME, "where id=#{id};"})
    public Affiliation selectById(@Param("id") Integer id);
}
