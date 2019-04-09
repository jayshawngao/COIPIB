package seu.dao;


import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;
import seu.BaseTest;
import seu.model.User;

@Transactional
@Rollback
public class UserDAOTest extends BaseTest{

    @Autowired
    private UserDAO userDAO;

    @Test
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

    @Test
    public void testSelectById() {
        System.out.println(userDAO.selectById(5));
    }

    @Test
    public void testSelectByName() {
        System.out.println(userDAO.selectByName("AA"));
    }

}
