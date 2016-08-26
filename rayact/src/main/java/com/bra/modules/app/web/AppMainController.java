package com.bra.modules.app.web;

import com.bra.common.persistence.Page;
import com.bra.modules.reserve.entity.ReserveField;
import com.bra.modules.reserve.service.ReserveFieldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by xiaobin on 16/1/25.
 */
@Controller
@RequestMapping(value = "${adminPath}/app")
public class AppMainController {
    @Autowired
    private ReserveFieldService reserveFieldService;

    @RequestMapping(value = "main")
    public String main(ReserveField reserveField, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ReserveField> page = reserveFieldService.findPage(new Page<>(request, response), reserveField);
        model.addAttribute("page", page);
        return "app/index";
    }
}
