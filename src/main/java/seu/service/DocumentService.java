package seu.service;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import seu.base.CodeEnum;
import seu.base.PageInfo;
import seu.base.Pagination;
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
        checkDocument(document);
        if (documentDAO.insert(document) != 1){
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "文档插入失败");
        }
    }

    public void updateDocument(Document document) throws COIPIBException {
        checkDocument(document);
        if (documentDAO.update(document) != 1){
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "文档更新失败");
        }
    }

    private void checkDocument(Document document) throws COIPIBException {
        User user = hostHolder.getUser();
        if (document.getAuth() > user.getLevel()) {
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "文献密级不能高于当前用户等级！");
        }
    }

    /**
     * 管理员通过
     */
    public void activeDocument(Integer id) throws COIPIBException {
        checkDocumentId(id);
        userService.adminAuth();

        Document document = documentDAO.selectById(id);
        document.setActive(0);
        documentDAO.update(document);
    }

    public void moveDocumentToBin(Integer id) throws COIPIBException{
        checkDocumentId(id);

        Document document = documentDAO.selectById(id);
        document.setAffiliationId(-Math.abs(document.getAffiliationId()));
        documentDAO.update(document);
    }

    public void deleteDocument(Integer id) throws COIPIBException {
        checkDocumentId(id);

        documentDAO.delete(id);

    }

    public void recoverDocument(Integer id) throws COIPIBException {
        checkDocumentId(id);

        Document document = documentDAO.selectById(id);
        document.setAffiliationId(Math.abs(document.getAffiliationId()));
        documentDAO.update(document);
    }

    public Pagination<Document> queryAllDocument(Integer affiliationId, Integer page, Boolean isEdit, Boolean isActive)
                                                                                            throws COIPIBException{
        if (affiliationId == null) {
            affiliationId = 100; // 未分类
        }
        if (page == null) {
            page = 1;
        }
        if (isEdit == null) {
            isEdit = false;
        }
        if (isActive == null) {
            isActive = false;
        }
        if (isEdit == true && isActive == true) {
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "isEdit isActive 不能同时为true");
        }
        if (isActive == true) {
            userService.adminAuth();
        }
        List<Document> documentList = new ArrayList<>();

        Affiliation affiliation = affiliationService.getById(affiliationId);
        if (affiliation != null) {
            documentList.addAll(documentDAO.selectByAffiliationId(affiliation.getId(), hostHolder.getUser(), isEdit, isActive));
            if (affiliation.getParentId() == 0) {
                // 查询所有子归属包含的文档
                List<Affiliation> childList = affiliationService.showAllChildren(affiliation.getId());
                for (Affiliation child: childList) {
                    documentList.addAll(documentDAO.selectByAffiliationId(child.getId(), hostHolder.getUser(), isEdit, isActive));
                }
            }
        }
        return buildPagination(documentList, page);

    }

    private Pagination<Document> buildPagination(List<Document> documentList, Integer page){
        PageInfo pageInfo = new PageInfo(documentList.size(), page);
        documentList = documentList.subList(pageInfo.getBeginIndex(), pageInfo.getEndIndex());
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

    public Pagination<Document> simpleSearch(String name, Integer page, Boolean isEdit, Boolean isActive) throws COIPIBException{
        if (StringUtils.isBlank(name)) {
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "搜索内容不能为空！");
        }
        if (page == null) {
            page = 1;
        }
        if (isEdit == null) {
            isEdit = false;
        }
        if (isActive == null) {
            isActive = false;
        }
        if (isEdit == true && isActive == true) {
            throw new COIPIBException(CodeEnum.DOCUMENT_ERROR, "isEdit isActive 不能同时为true");
        }
        if (isActive == true) {
            userService.adminAuth();
        }
        Integer totalRow = documentDAO.countSimpleSearch(name, hostHolder.getUser(), isEdit, isActive);
        PageInfo pageInfo = new PageInfo(totalRow, page);
        List<Document> documentList = documentDAO.simpleSearch(name, hostHolder.getUser(), isEdit, isActive,
                pageInfo.getBeginIndex(), pageInfo.getEndIndex());
        return new Pagination<Document>(documentList, pageInfo);
    }

}
