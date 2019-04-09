package seu.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Component;
import seu.model.User;

import java.util.HashMap;
import java.util.Map;

@Mapper
public interface UserDAO {

    Integer persist(User user);

    Integer update(User user);
}
