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
import seu.model.HostHolder;
import seu.model.User;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class DocumentService {

    @Autowired
    private DocumentDAO documentDAO;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private UserService userService;

    @Autowired
    private AffiliationService affiliationService;

    @Autowired
    private HostHolder hostHolder;

    public void insertNewDocument(Document document) throws COIPIBException{
        if (documentDAO.insert(document) != 1){
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "文档插入数据库失败");
        }
    }

    /**
     * 管理员通过
     */
    public void activeDocument(Integer id) throws COIPIBException {
        checkDocumentId(id);
        if (!userService.adminAuth()) {
            throw new COIPIBException("权限不足！");
        }

        Document document = documentDAO.selectById(id);
        document.setActive(0);
        documentDAO.updateDocument(document);
    }

    public void moveDocumentToBin(Integer id) throws COIPIBException{
        checkDocumentId(id);

        Document document = documentDAO.selectById(id);
        document.setAffiliationId(200); // 回收站
        documentDAO.updateDocument(document);
    }

    public void deleteDocument(Integer id) throws COIPIBException {
        checkDocumentId(id);

        documentDAO.deleteDocument(id);

    }

    public Pagination<Document> queryAllDocument(Integer affiliationId, Integer page) throws COIPIBException {
        if (affiliationId == null) {
            affiliationId = 100; // 未分类
        }
        if (page == null) {
            page = 1;
        }
        List<Document> documentList = new ArrayList<>();

        Affiliation affiliation = affiliationService.getById(affiliationId);
        if (affiliation != null) {
            documentList.addAll(documentDAO.selectByAffiliationId(affiliation.getId(), hostHolder.getUser()));
            if (affiliation.getParentId() == 0) {
                // 查询所有子归属包含的文档
                List<Affiliation> childList = affiliationService.showAllChildren(affiliation.getId());
                for (Affiliation child: childList) {
                    documentList.addAll(documentDAO.selectByAffiliationId(child.getId(), hostHolder.getUser()));
                }
            }
        }
        return buildPagination(documentList, page);

    }

    private Pagination<Document> buildPagination(List<Document> documentList, Integer page) throws COIPIBException{
        PageInfo pageInfo = new PageInfo(documentList.size(), page);
        documentList = documentList.subList(pageInfo.getBeginIndex(), pageInfo.getEndIndex();
        for (Document document: documentList) {
            fillDoucment(document);
        }
        return new Pagination<Document>(documentList, pageInfo);
    }

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

    private void checkDocumentId(Integer id) throws COIPIBException {
        if (id == null) {
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "参数不能为空！");
        }
        Document document = documentDAO.selectById(id);
        if (document == null) {
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "文献不存在！");
        }
    }

}
