package seu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PageController {

    @RequestMapping(path = {"/", "/index"})
    public String index() {
        return "index";
    }

    @RequestMapping("/login")
    public String login() {
        return "login";
    }

    @RequestMapping("/register")
    public String register() {
        return "register";
    }

    @RequestMapping("/findPassword")
    public String findPassword() {
        return "findPassword";
    }

    @RequestMapping("/modifyPassword")
    public String modifyPassword(){
        return "modifyPassword";
    }

    @RequestMapping("/updatePassword")
    public String updatePassword(){
        return "updatePassword";
    }
}
