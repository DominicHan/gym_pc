package com.bra.modules.reserve.web;

import com.bra.common.config.Global;
import com.bra.common.persistence.Page;
import com.bra.common.utils.DateUtils;
import com.bra.common.web.BaseController;
import com.bra.modules.reserve.entity.*;
import com.bra.modules.reserve.service.*;
import com.bra.modules.reserve.utils.ExcelInfo;
import com.bra.modules.reserve.web.form.SaleVenueLog;
import com.bra.modules.reserve.web.form.TutorPeriodLog;
import com.bra.modules.sys.entity.User;
import com.bra.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 场地售卖日志表
 * Created by xiaobin on 16/1/28.
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/saleVenue")
public class SaleVenueLogController extends BaseController {

    @Autowired
    private ReserveVenueConsService reserveVenueConsService;
    @Autowired
    private ReserveFieldService reserveFieldService;
    @Autowired
    private ReserveUserService reserveUserService;
    @Autowired
    private ReserveVenueService reserveVenueService;
    @Autowired
    private ReserveProjectService reserveProjectService;
    @Autowired
    private ReserveVenueOrderService reserveVenueOrderService;

    @RequestMapping(value = "list")
    public String list(Model model, SaleVenueLog venueLog, HttpServletRequest request, HttpServletResponse response) {

        Page<SaleVenueLog> page = reserveVenueConsService.findOrderLog(new Page<>(request, response), venueLog);
        model.addAttribute("page", page);
        String userType=UserUtils.getUser().getUserType();
        model.addAttribute("userType", userType);

        model.addAttribute("fieldList",reserveFieldService.findList(new ReserveField()));
        model.addAttribute("userList",reserveUserService.findList(new User()));
        model.addAttribute("venueList",reserveVenueService.findList(new ReserveVenue()));
        List<ReserveProject> projectList = reserveProjectService.findList(new ReserveProject());
        model.addAttribute("projectList",projectList);
        model.addAttribute("query",venueLog);//参数返回
        return "/reserve/record/saleVenueLog";
    }
    @RequestMapping(value = "tutorPeriodDetail")
    public String tutorPeriodDetail(Model model, SaleVenueLog venueLog, HttpServletRequest request, HttpServletResponse response) {

        Page<SaleVenueLog> page = reserveVenueConsService.findOrderLog(new Page<>(request, response), venueLog);
        model.addAttribute("page", page);
        model.addAttribute("query",venueLog);//参数返回
        return "/reserve/report/tutorPeriodDetail";
    }
    @RequestMapping(value = "tutorPeriodReport")
    public String tutorPeriodReport(Model model, TutorPeriodLog log, HttpServletRequest request, HttpServletResponse response) {

        Page<TutorPeriodLog> page = reserveVenueConsService.tutorPeriodReportPage(new Page<>(request, response), log);
        model.addAttribute("page", page);
        model.addAttribute("fieldList",reserveFieldService.findList(new ReserveField()));
        model.addAttribute("venueList",reserveVenueService.findList(new ReserveVenue()));
        model.addAttribute("query",log);//参数返回
        return "/reserve/report/tutorPeriodReport";
    }

    @RequestMapping(value = "listExport")
    public void listExport(SaleVenueLog venueLog,  HttpServletRequest request,HttpServletResponse response)throws Exception {

        List<SaleVenueLog> sellLogs = reserveVenueConsService.findOrderLogList(venueLog);
        String[] titles = {"所属场馆","时间区间","订单金额","应收金额","优惠金额","实收金额","支付类型","预定人","操作人","授权人","教练","订单时间","操作时间"};
        List<String[]> contentList = new ArrayList<>();
        for(SaleVenueLog log :sellLogs){
            String[] o = new String[14];
            o[0] = log.getVenue().getName();
            o[2] = log.getStartTime()+"-"+log.getEndTime();
            o[3] = String.valueOf(log.getOrderPrice());
            o[4] = String.valueOf(log.getShouldPrice());
            o[5] = String.valueOf(log.getDiscountPrice());
            o[6] = String.valueOf(log.getConsPrice());
            o[7] = log.getPayType();
            o[8] = log.getMember().getName();
            o[9] = log.getCreateBy().getName();
            o[10] = log.getCheckoutName();
            o[11] = log.getTutorName();
            SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
            o[12] = String.valueOf(format.format(log.getConsDate()));
            SimpleDateFormat myFmt=new SimpleDateFormat("yyyy-MM-dd HH:mm");
            o[13] =String.valueOf(myFmt.format(log.getUpdateDate()));
            contentList.add(o);
        }
        Date now = new Date();
        ExcelInfo info = new ExcelInfo(response,"场地售卖报表"+ DateUtils.formatDate(now),titles,contentList);
        info.export();
    }
    @RequestMapping(value = "delete")
    private String delete(String orderId,String isTicket,RedirectAttributes redirectAttributes){
        if("1".equals(isTicket)){
            ReserveVenueOrder order =reserveVenueOrderService.get(orderId);
            reserveVenueOrderService.delete(order);
        }else{
            ReserveVenueCons order=reserveVenueConsService.get(orderId);
            reserveVenueConsService.delete(order);
        }
        addMessage(redirectAttributes, "删除记录成功");
        return "redirect:" + Global.getAdminPath() + "/reserve/saleVenue/list";
    }
}
