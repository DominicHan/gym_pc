package com.bra.modules.reserve.web;

import com.bra.common.config.Global;
import com.bra.common.persistence.ConstantEntity;
import com.bra.common.persistence.Page;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.common.web.annotation.Token;
import com.bra.modules.mechanism.web.bean.AttMainForm;
import com.bra.modules.reserve.entity.ReserveMember;
import com.bra.modules.reserve.entity.ReserveVenue;
import com.bra.modules.reserve.service.ReserveMemberService;
import com.bra.modules.reserve.service.ReserveVenueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 次卡会员管理
 * Created by jiangxingqi on 2016/1/5.
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/annualCardMember")
public class ReserveAnnualCardMemberController extends BaseController {

    @Autowired
    private ReserveMemberService reserveMemberService;

    @Autowired
    private ReserveVenueService reserveVenueService;

    @ModelAttribute
    public ReserveMember get(@RequestParam(required=false) String id) {
        ReserveMember entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = reserveMemberService.get(id);
        }
        if (entity == null){
            entity = new ReserveMember();
        }
        return entity;
    }

    @RequestMapping(value = "list")
    public String annualCardList(ReserveMember reserveMember, HttpServletRequest request, HttpServletResponse response, Model model){
        reserveMember.setAnnualCardFlag(ConstantEntity.YES);
        Page<ReserveMember> page = reserveMemberService.findPage(new Page<>(request, response), reserveMember);
        model.addAttribute("page", page);
        return "reserve/member/annualCardMemberList";
    }

    @RequestMapping(value = "form")
    @Token(save=true)
    public String form(ReserveMember reserveMember, Model model) {

        List<ReserveVenue> venueList=reserveVenueService.findList(new ReserveVenue());
        model.addAttribute("venueList", venueList);
        model.addAttribute("reserveMember", reserveMember);
        return "reserve/member/annualCardMemberForm";
    }

    @RequestMapping(value = "save")
    @Token(remove=true)
    public String save(ReserveMember reserveMember, AttMainForm attMainForm, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, reserveMember)) {
            return form(reserveMember, model);
        }
        reserveMember.setAnnualCardFlag(ConstantEntity.YES);
        reserveMemberService.save(reserveMember,attMainForm);
        addMessage(redirectAttributes, "保存年卡会员成功");
        return "redirect:"+ Global.getAdminPath()+"/reserve/annualCardMember/list";
    }

    @RequestMapping(value = "delete")
    public String delete(ReserveMember reserveMember, RedirectAttributes redirectAttributes) {
        reserveMemberService.delete(reserveMember);
        addMessage(redirectAttributes, "删除年卡会员成功");
        return "redirect:"+Global.getAdminPath()+"/reserve/annualCardMember/list";
    }
}
