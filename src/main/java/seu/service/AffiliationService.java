package seu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import seu.base.CodeEnum;
import seu.dao.AffiliationDAO;
import seu.exceptions.COIPIBException;
import seu.model.Affiliation;

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
 }
