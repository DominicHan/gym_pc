package com.bra.modules.app.web;

import com.bra.modules.app.service.AppFieldService;
import com.bra.modules.app.utils.MemberUtils;
import com.bra.modules.reserve.entity.ReserveField;
import com.bra.modules.reserve.entity.ReserveMember;
import com.bra.modules.reserve.entity.ReserveVenue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * Created by jiangxingqi on 16/1/25.
 */
@Controller
@RequestMapping(value = "${adminPath}/app")
public class AppMainController {
    @Autowired
    private AppFieldService fieldService;

    @RequestMapping(value = "main")
    public String main(ReserveField reserveField, Model model) {
        ReserveMember member = MemberUtils.getMember();
        ReserveVenue venue=member.getReserveVenue();
        reserveField.setReserveVenue(venue);
        List<ReserveField> list = fieldService.findList(reserveField);
        model.addAttribute("list", list);
        model.addAttribute("reserveVenueId", venue.getId());
        return "app/index";
    }
}
