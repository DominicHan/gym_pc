package com.bra.modules.reserve.web;

import com.bra.common.config.Global;
import com.bra.common.persistence.Page;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.common.web.annotation.Token;
import com.bra.modules.mechanism.web.bean.AttMainForm;
import com.bra.modules.reserve.entity.*;
import com.bra.modules.reserve.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.DecimalFormat;
import java.util.List;

/**
 * 次卡会员管理
 * Created by jiangxingqi on 2016/1/5.
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/timeCardMember")
public class ReserveTimeCardMemberController extends BaseController {

    @Autowired
    private ReserveMemberService reserveMemberService;

    @Autowired
    private ReserveTimecardMemberSetService timecardSetService;

    @Autowired
    private ReserveVenueService reserveVenueService;
    @Autowired
    private ReserveCardStatementsService reserveCardStatementsService;
    @Autowired
    private ReserveTimeCardPrepaymentService reserveTimeCardPrepaymentService;

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
    public String list(ReserveMember reserveMember, HttpServletRequest request, HttpServletResponse response, Model model){
        Page<ReserveMember> page = reserveMemberService.findPage(new Page<>(request, response), reserveMember);
        model.addAttribute("page", page);
        return "reserve/member/timeCardMemberList";
    }
    //储值冲次数
    @RequestMapping(value = "addTimeForm")
    public String addTimeForm(String id,String periodPrice,Model model){
        ReserveMember reserveMember = reserveMemberService.get(id);
        model.addAttribute("reserveMember", reserveMember);
        model.addAttribute("periodPrice", periodPrice);
        return "reserve/member/timeCardAddForm";
    }
    //次卡充值保存
    /**
     *
     * @param id
     * @param rechargeVolume
     * @param time 次数
     * @param payType
     * @param remarks
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "addTime")
    public String addTime(String id, Double rechargeVolume,int time,String payType,String remarks,RedirectAttributes redirectAttributes){
        ReserveMember reserveMember = reserveMemberService.get(id);
        //预付款记录
        ReserveTimeCardPrepayment prepayment=new ReserveTimeCardPrepayment();
        prepayment.setType("1");
        prepayment.setRemainder(rechargeVolume);
        prepayment.setRemainTime(time);
        prepayment.setReserveMember(reserveMember);
        double singlePrice=rechargeVolume/time;
        DecimalFormat df=new DecimalFormat("0.00");
        singlePrice=new Double(df.format(singlePrice).toString());
        prepayment.setSingleTimePrice(singlePrice);
        reserveTimeCardPrepaymentService.save(prepayment);
        //预付款 结束
        //余额 剩余次数 更新
        int residue=reserveMember.getResidue();
        double remain=0.0;
        if(reserveMember.getRemainder()!=null){
            remain=reserveMember.getRemainder();
        }
        if("1".equals(payType)){
            remain-=rechargeVolume;//金额减
        }
        residue+=time;//次数添加
        reserveMember.setResidue(residue);
        reserveMember.setRemainder(remain);
        reserveMemberService.save(reserveMember);
        //余额 剩余次数 更新 结束
        //记录次卡充值记录
        ReserveCardStatements statement=new ReserveCardStatements();
        statement.setReserveMember(reserveMember);
        statement.setTransactionNum(time);
        statement.setTransactionVolume(rechargeVolume);
        statement.setTransactionType("7");
        statement.setPayType(payType);
        statement.setVenue(reserveMember.getReserveVenue());
        statement.setRemarks(remarks);
        reserveCardStatementsService.save(statement);
        return "redirect:"+ Global.getAdminPath()+"/reserve/timeCardMember/list";
    }

    @RequestMapping(value = "form")
    @Token(save=true)
    public String form(ReserveMember reserveMember, Model model) {
        List<ReserveVenue> venueList=reserveVenueService.findList(new ReserveVenue());
        model.addAttribute("venueList", venueList);
        model.addAttribute("reserveMember", reserveMember);
        return "reserve/member/timeCardMemberForm";
    }

    @RequestMapping(value = "save")
    @Token(remove=true)
    public String save(ReserveMember reserveMember, AttMainForm attMainForm, Model model, RedirectAttributes redirectAttributes) {

        if (!beanValidator(model, reserveMember)){
            return form(reserveMember, model);
        }
        reserveMemberService.save(reserveMember,attMainForm);
        addMessage(redirectAttributes, "保存次卡会员成功");
        return "redirect:"+ Global.getAdminPath()+"/reserve/timeCardMember/list";
    }

    @RequestMapping(value = "delete")
    public String delete(ReserveMember reserveMember, RedirectAttributes redirectAttributes) {
        reserveMemberService.delete(reserveMember);
        addMessage(redirectAttributes, "删除次卡会员成功");
        return "redirect:"+Global.getAdminPath()+"/reserve/timeCardMember/list";
    }
}
