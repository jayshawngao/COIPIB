package seu;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import seu.base.PageInfo;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml", "classpath:spring-mvc.xml"})
public class BaseTest {

    /**
     * 加个空方法防止maven test报错
     */
    @Test
    public void test(){
    }
}
