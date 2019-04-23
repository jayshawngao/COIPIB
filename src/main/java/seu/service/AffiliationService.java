package seu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import seu.base.CodeEnum;
import seu.dao.AffiliationDAO;
import seu.exceptions.COIPIBException;
import seu.model.Affiliation;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class AffiliationService {

    @Autowired
    AffiliationDAO affiliationDAO;

    public List<Affiliation> showFirstLevel(){
        return affiliationDAO.selectFirstLevel();
    }

    public List<Affiliation> showAllChildren(Integer parentId){
        return affiliationDAO.selectChildren(parentId);
    }

    public void deleteAffiliationById(Integer id) throws COIPIBException{
        if (affiliationDAO.delete(id) != 1){
            throw new COIPIBException(CodeEnum.DATABASE_ERROR, "数据库删除失败");
        }
    }

    public void insertNewAffiliation(Affiliation affiliation)throws COIPIBException{
        if (affiliationDAO.insert(affiliation) != 1){
            throw new COIPIBException(CodeEnum.DATABASE_ERROR, "数据库插入失败");
        }
    }

    public void EditAffiliation(Affiliation affiliation)throws COIPIBException{
        if (affiliationDAO.update(affiliation) != 1){
            throw new COIPIBException(CodeEnum.DATABASE_ERROR, "数据库更新失败");
        }
    }

    public Affiliation getById(Integer id){
        return affiliationDAO.selectById(id);
    }

    /**
     * 从一级菜单到末级菜单，例：[发达国家, 美国]
     */
    public List<Affiliation> queryAffiliationList(Integer id) {
        List<Affiliation> ret = new ArrayList<>();
        Affiliation affiliation = affiliationDAO.selectById(id);
        if (affiliation == null) {
            return ret;
        }
        ret.add(affiliation);

        if (affiliation.getParentId() != 0) {
            Affiliation parent = affiliationDAO.selectById(affiliation.getParentId());
            ret.add(0, parent);
        }
        return ret;
    }
 }
