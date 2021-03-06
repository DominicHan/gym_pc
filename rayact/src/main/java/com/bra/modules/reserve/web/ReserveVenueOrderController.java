package com.bra.modules.reserve.web;

import com.alibaba.fastjson.JSON;
import com.bra.common.config.Global;
import com.bra.common.persistence.Page;
import com.bra.common.utils.DateUtils;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.common.web.ViewResult;
import com.bra.common.web.annotation.Token;
import com.bra.modules.reserve.entity.*;
import com.bra.modules.reserve.service.*;
import com.bra.modules.reserve.utils.TimeUtils;
import com.bra.modules.sys.entity.User;
import com.bra.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;

/**
 * 场地订单Controller
 *
 * @author 肖斌
 * @version 2016-01-19
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/reserveVenueOrder")
public class ReserveVenueOrderController extends BaseController {
    @Autowired
    private ReserveVenueOrderService reserveVenueOrderService;
    @Autowired
    private ReserveVenueVisitorsSetService reserveVenueVisitorsSetService;
    @Autowired
    private ReserveFieldService reserveFieldService;
    @Autowired
    private ReserveVenueService reserveVenueService;
    @Autowired
    private ReserveTutorService reserveTutorService;
    @Autowired
    private ReserveMemberService reserveMemberService;
    @Autowired
    private ReserveProjectService reserveProjectService;
    @Autowired
    private ReserveUserService reserveUserService;

    @RequestMapping(value = "list")
    public String list(ReserveVenueOrder reserveVenueOrder, HttpServletRequest request, HttpServletResponse response,Model model) {

        model.addAttribute("userList",reserveUserService.findList(new User()));
        ReserveVenue venue = new ReserveVenue();
        model.addAttribute("venueList",reserveVenueService.findList(venue));
        List<ReserveProject> projectList = reserveProjectService.findList(new ReserveProject());
        model.addAttribute("projectList",projectList);
        model.addAttribute("query",reserveVenueOrder);//参数返回
        String userType= UserUtils.getUser().getUserType();
        model.addAttribute("userType", userType);
        Page<ReserveVenueOrder> page = reserveVenueOrderService.findPage(new Page<ReserveVenueOrder>(request, response),reserveVenueOrder);
        model.addAttribute("page", page);
        return "reserve/record/nonTutorOrderList";
    }

    //人次票 付款界面
    @RequestMapping(value = "form")
    @Token(save = true)
    public String form(String vsId, String venueId, Model model) {
        ReserveVenueVisitorsSet set = reserveVenueVisitorsSetService.get(vsId);
        ReserveVenue venue = reserveVenueService.get(venueId);
        ReserveField field = new ReserveField();
        field.setReserveVenue(venue);
        List<ReserveField> fieldList = reserveFieldService.findList(field);
        model.addAttribute("fieldList", fieldList);
        model.addAttribute("visitorsSet", set);
        //会员
        ReserveMember member = new ReserveMember();
        model.addAttribute("memberList", reserveMemberService.findList(member));
        //获取预定开始时间
        String startTime = venue.getStartTime();
        String endTime = venue.getEndTime();
        if (StringUtils.isBlank(startTime)) {
            startTime = "06:00:00";
        }
        if (StringUtils.isBlank(endTime)) {
            endTime = "24:00:00";
        }
        List<String> times = TimeUtils.getTimeSpacList(startTime, endTime, TimeUtils.BENCHMARK);
        model.addAttribute("times", times);
        model.addAttribute("orderDate", new Date());
        return "reserve/visitorsSetOrder/form";
    }
    //确认购买
    @RequestMapping(value = "checkSave")
    @ResponseBody
    public String checkSave(ReserveVenueOrder reserveVenueOrder) {
        ViewResult rs=null;
        //如果是会员预订
        if (reserveVenueOrder.getMember() != null && StringUtils.isNoneEmpty(reserveVenueOrder.getMember().getId())) {
            if("12".equals(reserveVenueOrder.getPayType())) {
                ReserveMember member = reserveMemberService.get(reserveVenueOrder.getMember());
                if(member.getReserveVenue().getId().equals(reserveVenueOrder.getReserveVenue().getId())){
                    Date start=member.getValidityStart();
                    Date end=member.getValidityEnd();
                    if(start==null||end==null){
                        rs = new ViewResult(false, "课时有效期为空，请维护后再消费");
                    }else{
                        if(DateUtils.bettewn(start,end,new Date())){
                            int residue = member.getResidue();//剩余无教练课时
                            int ticketNum = reserveVenueOrder.getCollectCount();//买了几个课时
                            if (ticketNum > residue) {
                                rs = new ViewResult(false, "该用户剩余次数不足！剩余次数=" + residue);
                            } else {
                                rs = new ViewResult(true, "检测成功");
                            }
                        }else{
                            rs = new ViewResult(false, "课时已过期");
                        }
                    }
                }else{
                    rs = new ViewResult(false, "课时不可跨店使用");
                }

            }else{
                rs = new ViewResult(true, "检测成功");//预储值金额消费
            }
        } else {
            rs = new ViewResult(true, "检测成功");
        }
        return JSON.toJSONString(rs);
    }

    //确认购买
    @RequestMapping(value = "save")
    @ResponseBody
    @Token(remove = true)
    public String save(ReserveVenueOrder reserveVenueOrder) {
        String payType=reserveVenueOrder.getPayType();

        //如果是会员预订
        if (reserveVenueOrder.getMember() != null && StringUtils.isNoneEmpty(reserveVenueOrder.getMember().getId())) {
            //预储（无教练）课时
            if("12".equals(payType)){
                ReserveMember member = reserveMemberService.get(reserveVenueOrder.getMember());
                int residue = member.getResidue();//次卡剩余次数 等于 预付款的次数之和
                int ticketNum = reserveVenueOrder.getCollectCount();//买了几个课时
                residue -= ticketNum;//修改该用户的剩余次数
                member.setResidue(residue);//保存剩余次数
                reserveMemberService.save(member);
                reserveVenueOrder.setMember(member);
                reserveVenueOrderService.save(reserveVenueOrder);//会员结算保存
            }else {
                reserveVenueOrderService.save(reserveVenueOrder);//会员结算保存
            }
        } else {
            reserveVenueOrderService.save(reserveVenueOrder);//非会员
        }
        ViewResult rs = new ViewResult(true, "保存成功");
        return JSON.toJSONString(rs);
    }

    @RequestMapping(value = "delete")
    public String delete(ReserveVenueOrder reserveVenueOrder, RedirectAttributes redirectAttributes) {
        reserveVenueOrderService.delete(reserveVenueOrder);
        addMessage(redirectAttributes, "删除场地订单成功");
        return "redirect:" + Global.getAdminPath() + "/reserve/reserveVenueOrder/?repage";
    }

}