package com.bra.modules.app.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by xiaobin on 16/1/25.
 */
@Controller
@RequestMapping(value = "${adminPath}/app")
public class AppMainController {

    @RequestMapping(value = "main")
    public String main(Model model) {
        return "app/index";
    }
}
