package seu;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.aop.scope.ScopedProxyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import seu.base.PageInfo;
import seu.dao.DocumentDAO;
import seu.model.Document;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml", "classpath:spring-mvc.xml"})
public class BaseTest {

    @Autowired
    private DocumentDAO documentDAO;

    /**
     * 加个空方法防止maven test报错
     */
    @Test
    public void test(){
        Document document = new Document();
        document.setName("中文");
        document.setAuthor("中文");
        document.setKeywords("中文");
        document.setDigest("中文");
        document.setTopic("中文");
        document.setAffiliationId(1);
        document.setYear(1999);
        document.setEditorId(5);
        document.setAuth(0);

        documentDAO.insert(document);
    }
}
