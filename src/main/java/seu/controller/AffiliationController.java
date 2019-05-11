package seu.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import seu.base.CodeEnum;
import seu.base.CommonResponse;
import seu.exceptions.COIPIBException;
import seu.model.Affiliation;
import seu.service.AffiliationService;

import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/affiliation")
public class AffiliationController {

    private static final Logger LOGGER = LoggerFactory.getLogger(AffiliationController.class);

    @Autowired
    AffiliationService affiliationService;

    @RequestMapping("/showFirstLayer")
    @ResponseBody
    public String showFirstLayer(){
        try{
            List<Affiliation> resultList = affiliationService.showFirstLevel();
            HashMap<String, Object> data = new HashMap<>();
            data.put("affiliationList", resultList);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "查询一级归属成功", data).toJSONString();
        }catch (Exception e){
            LOGGER.error("/affiliation/showFirstLayer", e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/showNextLayer")
    @ResponseBody
    public String showNextLayer(Integer parentId){
        try{
            List<Affiliation> children = affiliationService.showAllChildren(parentId);
            HashMap<String, Object> data = new HashMap<>();
            data.put("childrenList", children);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "查询二级归属成功", data).toJSONString();
        }catch (Exception e){
            LOGGER.error("/affiliation/showNextLayer parameter: parentId={}", parentId, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/insert")
    @ResponseBody
    public String insertNewAffiliation(Affiliation affiliation){
        try{
            if (affiliation.getParentId() == null){
                affiliation.setParentId(0);
            }
            affiliationService.insertNewAffiliation(affiliation);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "插入归属成功").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: affiliation={}", affiliation);
            return new CommonResponse(CodeEnum.AFFILIATION_ERROR.getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/affiliation/insert" + " parameter: affiliation={}", affiliation, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/delete")
    @ResponseBody
    public String deleteAffiliationById(Integer id){
        try{

            affiliationService.deleteAffiliationById(id);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "删除归属成功").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: id={}", id);
            return new CommonResponse(CodeEnum.AFFILIATION_ERROR.getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/affiliation/delete" + " parameter: id={}", id, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @RequestMapping("/update")
    @ResponseBody
    public String updateAffiliation(Affiliation affiliation){
        try{
            if (affiliation.getParentId() == null){
                affiliation.setParentId(0);
            }
            affiliationService.editAffiliation(affiliation);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "修改归属成功").toJSONString();
        }catch (COIPIBException e){
            LOGGER.info(e.getMessage() + " parameter: affiliation={}", affiliation);
            return new CommonResponse(CodeEnum.AFFILIATION_ERROR.getValue(), e.getMessage()).toJSONString();
        }catch (Exception e){
            LOGGER.error("/affiliation/update" + " parameter: affiliation={}", affiliation, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

    @ResponseBody
    @RequestMapping("getById")
    public String getAffiliation(Integer id){
        try{
            Affiliation affiliation = affiliationService.getById(id);
            HashMap<String, Object> data = new HashMap<>();
            data.put("affiliation", affiliation);
            return new CommonResponse(CodeEnum.SUCCESS.getValue(), "获取归属成功", data).toJSONString();
        }catch (Exception e){
            LOGGER.error("/affiliation/getById" + " parameter: id={}", id, e);
            return new CommonResponse(CodeEnum.UNKNOWN_ERROR.getValue(), e.getMessage()).toJSONString();
        }
    }

}
