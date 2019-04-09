package seu.dao;


import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;
import seu.BaseTest;
import seu.model.User;

public class UserDAOTest extends BaseTest{

    @Autowired
    private UserDAO userDAO;

    @Test
    @Transactional
    @Rollback(value = false)
    public void testPersist() {
        User user = new User();
        user.setName("AA");
        user.setPassword("123456");
        user.setEmail("xx@xx.com");
        userDAO.persist(user);
    }

    @Test
    public void testUpdate() {
        User user = new User();
        user.setId(5);
        user.setEmail("yy@yy.com");
        user.setActive(0);
        userDAO.update(user);
    }

}
