package seu.dao;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import seu.BaseTest;
import seu.model.Affiliation;

public class AffiliationDAOTest extends BaseTest {
    @Autowired
    AffiliationDAO affiliationDAO;

    @Test
    public void testDelete(){
        affiliationDAO.delete(2);
    }

    @Test
    public void testInsert(){
        Affiliation affiliation = new Affiliation();
        affiliation.setName("1112");
        affiliation.setParentId(0);
        affiliationDAO.insert(affiliation);
        System.out.println(affiliation.getId());
    }

    @Test
    public void testUpdate(){
        Affiliation affiliation = new Affiliation();
        affiliation.setId(3);
        affiliation.setName("pptv");
        affiliation.setParentId(3);
        System.out.println(affiliationDAO.update(affiliation));
    }

    @Test
    public void testSelectAll(){
        System.out.println(affiliationDAO.selectFirstLevel());
    }

    @Test
    public void testSelectById(){
        System.out.println(affiliationDAO.selectChildren(2));
    }
}
