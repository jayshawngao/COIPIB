package seu.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import seu.base.CodeEnum;
import seu.base.CommonResponse;
import seu.base.Pagination;
import seu.exceptions.COIPIBException;
import seu.model.Document;
import seu.service.DocumentService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.HashMap;
import java.util.UUID;

@Controller
@RequestMapping("/document")
public class DocumentController {

    private static final Logger LOGGER = LoggerFactory.getLogger(DocumentController.class);

    @Autowired
    DocumentService documentService;

    @RequestMapping("/insert")
    @ResponseBody
    public String insertNewDocument(Document document){
        try{
            documentService.insertNewDocument(document);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "插入文档成功").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: document={}", document);
            return new CommonResponse(CodeEnum.DOCUMENT_ERROR.getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/document/insert" + " parameter: document={}", document, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/update")
    @ResponseBody
    public String updateDocument(Document document){
        try{
            documentService.updateDocument(document);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "更新文档成功").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: document={}", document);
            return new CommonResponse(CodeEnum.DOCUMENT_ERROR.getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/document/update" + " parameter: document={}", document, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping(value = "/upload")
    @ResponseBody
    public String uploadFile(@RequestParam(value="file") MultipartFile file, HttpServletRequest request, HttpServletResponse response){
        System.out.println("file = " + file);
        String fileDirectory = request.getServletContext().getRealPath("/") + "/static/file/";
        String fileName = file.getOriginalFilename();
        System.out.println(fileName);
        fileName = UUID.randomUUID().toString() + fileName.substring(fileName.lastIndexOf("."));
        String filePath= fileDirectory + fileName;
        try{
            FileOutputStream os = new FileOutputStream(filePath);
            InputStream is = file.getInputStream();
            byte[] buff = new byte[1024];
            while(is.read(buff) != -1){
                os.write(buff);
                os.flush();
            }
            os.close();
            is.close();
            HashMap<String, Object> data = new HashMap<>();
            data.put("attachment", response.encodeURL(request.getServletContext().getContextPath()+"/static/file/"+fileName));
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "文件上传成功", data).toJSONString();
        }catch (IOException e){
            LOGGER.info(e.getMessage() + " parameter: file={}", file);
            return new CommonResponse(CodeEnum.FILE_UPLOAD_ERROR.getValue(), "文件上传失败").toJSONString();
        }catch (Exception e){
            LOGGER.error("/document/upload" + " parameter: file={}", file, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/remove")
    @ResponseBody
    public String moveDocumentToBin(Integer id){
        try{
            documentService.moveDocumentToBin(id);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "文档移入回收站").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: id={}", id);
            return new CommonResponse(CodeEnum.DOCUMENT_ERROR.getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/document/remove" + " parameter: id={}", id, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/delete")
    @ResponseBody
    public String deleteDocument(Integer id){
        try{
            documentService.deleteDocument(id);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "删除文档成功").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: id={}", id);
            return new CommonResponse(e.getCodeEnum().getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/document/delete" + " parameter: id={}", id, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }


    /**
     * 文献页：isEdit=false，isActive=false （如果传空值，默认情况）
     * 编辑页：isEdit=true，isActive=false
     * 审核页：isEdit=false，isActive=true
     * 非法参数：isEdit=true，isActive=true
     *
     * @param affiliationId == null || 100: 未分类; 200：回收站
     * @param page
     * @param isEdit
     * @param isActive
     * @return
     */
    @RequestMapping("/showAllDocument")
    @ResponseBody
    public String showAllDocument(Integer affiliationId, Integer page, Boolean isEdit, Boolean isActive) {
        try {
            Pagination<Document> pagination = documentService.queryAllDocument(affiliationId, page, isEdit, isActive);
            HashMap<String, Object> data = new HashMap<>();
            data.put("pagination", pagination);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "文档查询成功", data).toJSONString();
        } catch (COIPIBException e) {
            LOGGER.info(e.getMessage() + " parameter:affiliationId={}, page={}, isEdit={}, isActive={}",
                    affiliationId, page, isEdit, isActive);
            return new CommonResponse(e.getCodeEnum().getValue(), e.getMessage()).toJSONString();
        } catch (Exception e) {
            LOGGER.error("/document/showAllDocument parameter:affiliationId={}, page={}, isEdit={}, isActive={}",
                    affiliationId, page, isEdit, isActive, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/recover")
    @ResponseBody
    public String recoverDocument(Integer id) {
        try{
            documentService.recoverDocument(id);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "文档还原成功").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: id={}", id);
            return new CommonResponse(e.getCodeEnum().getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/document/remove" + " parameter: id={}", id, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

}
