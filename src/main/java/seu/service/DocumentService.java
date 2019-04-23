package seu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import seu.base.CodeEnum;
import seu.base.PageInfo;
import seu.base.Pagination;
import seu.dao.AffiliationDAO;
import seu.dao.DocumentDAO;
import seu.dao.UserDAO;
import seu.exceptions.COIPIBException;
import seu.model.Affiliation;
import seu.model.Document;
import seu.model.User;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class DocumentService {

    @Autowired
    DocumentDAO documentDAO;

    @Autowired
    UserDAO userDAO;

    @Autowired
    AffiliationService affiliationService;

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
        List<Document> documentList = documentDAO.showAllDocumentInBin();
        for (Document document: documentList) {
            fillDoucment(document);
        }
        return documentList;
    }

    /**
     * 所有查询语句都需要调用该方法
     * @param document
     */
    private void fillDoucment(Document document) {
        if (document == null) {
            return;
        }
        User user = userDAO.selectById(document.getEditorId());
        if (user != null) {
            document.setEditor(user.getName());
        }
        Affiliation affiliation = affiliationService.getById(document.getAffiliationId());
        if (affiliation != null) {
            document.setAffiliationList(affiliationService.queryAffiliationList(affiliation.getId()));
        }

    }

    /**
     * 显示每个子目录下的所有文档
     * @return
     */
    public List<Document> showChildDocument() {
        return documentDAO.showChildDocument();
    }

    public Pagination<Document> queryAllDocument(Integer affiliationId, Integer page) throws COIPIBException {
        if (affiliationId == null || page == null) {
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "参数不能为空！");
        }
        List<Document> documentList = new ArrayList<>();

        Affiliation affiliation = affiliationService.getById(affiliationId);
        if (affiliation != null) {
            documentList.addAll(documentDAO.selectByAffiliationId(affiliation.getId()));
            if (affiliation.getParentId() == 0) {
                // 查询所有子归属包含的文档
                List<Affiliation> childList = affiliationService.showAllChildren(affiliation.getId());
                for (Affiliation child: childList) {
                    documentList.addAll(documentDAO.selectByAffiliationId(child.getId()));
                }
            }
        }
        PageInfo pageInfo = new PageInfo(documentList.size(), page);
        Pagination<Document> pagination = new Pagination<Document>(documentList.subList(pageInfo.getBeginIndex(),
                pageInfo.getEndIndex()), pageInfo);
        return pagination;

    }
}
