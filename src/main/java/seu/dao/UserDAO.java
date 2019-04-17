package seu.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import seu.model.User;


@Mapper
public interface UserDAO {

    String TABLE_NAME = " user ";
    String SELECT_FIELDS = " id, name, password, email, level, active, create_time, update_time ";

    Integer persist(User user);

    Integer update(User user);

    @Select({"select ", SELECT_FIELDS, " from ", TABLE_NAME, " where id=#{id}"})
    User selectById(Integer id);

    @Select({"select ", SELECT_FIELDS, " from ", TABLE_NAME, " where name=#{name}"})
    User selectByName(String name);

    @Select({"select ", SELECT_FIELDS, " from ", TABLE_NAME, " where email=#{email}"})
    User selectByEmail(String email);

    @Update({"update ", TABLE_NAME, " set password=#{newPassword} where email=#{email}"})
    Integer updatePassword(@Param("email") String email, @Param("newPassword") String newPassword);
}
