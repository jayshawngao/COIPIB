package seu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import seu.dao.DocumentDAO;
import seu.exceptions.COIPIBException;
import seu.model.Document;

import java.util.List;

@Service
@Transactional
public class DocumentService {

    @Autowired
    DocumentDAO documentDAO;

    public void insertNewDocument(Document document) throws COIPIBException{
        if (documentDAO.insert(document) != 1){
            throw new COIPIBException("文档插入数据库失败");
        }
    }

    public void moveDocumentToBin(Integer id) throws COIPIBException{
        if (documentDAO.moveDocumentIntoBin(id) != 1){
            throw new COIPIBException("文档从数据库删除失败/不存在对应文档");
        }
    }

    public void deleteDocument(Integer id) throws COIPIBException{
        if (documentDAO.deleteDocument(id) != 1){
            throw new COIPIBException("文档从数据库删除失败/不存在对应文档");
        }
    }

    public void editDocument(Document document){

    }

    public List<Document> showAllDocumentInBin(){
        return documentDAO.showAllDocumentInBin();
    }

    /**
     * 显示每个子目录下的所有文档
     * @return
     */
    public List<Document> showChildDocument() {
        return documentDAO.showChildDocument();
    }
}
