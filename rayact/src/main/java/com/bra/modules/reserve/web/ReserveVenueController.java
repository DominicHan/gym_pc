package com.bra.modules.reserve.web;

import com.bra.common.config.Global;
import com.bra.common.persistence.Page;
import com.bra.common.utils.DateUtils;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.common.web.annotation.Token;
import com.bra.modules.mechanism.web.bean.AttMainForm;
import com.bra.modules.reserve.entity.ReserveVenue;
import com.bra.modules.reserve.entity.form.ReserveVenueIncomeIntervalReport;
import com.bra.modules.reserve.entity.form.ReserveVenueProjectFieldIntervalReport;
import com.bra.modules.reserve.entity.form.ReserveVenueProjectIntervalReport;
import com.bra.modules.reserve.entity.form.ReserveVenueTotalIntervalReport;
import com.bra.modules.reserve.service.ReserveProjectService;
import com.bra.modules.reserve.service.ReserveVenueService;
import com.bra.modules.reserve.utils.CheckUtils;
import com.bra.modules.reserve.utils.ExcelInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 场馆管理Controller
 *
 * @author 肖斌
 * @version 2015-12-29
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/reserveVenue")
public class ReserveVenueController extends BaseController {

    @Autowired
    private ReserveVenueService reserveVenueService;

    @Autowired
    private ReserveProjectService reserveProjectService;

    @ModelAttribute
    public ReserveVenue get(@RequestParam(required = false) String id) {
        ReserveVenue entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = reserveVenueService.get(id);
        }
        if (entity == null) {
            entity = new ReserveVenue();
        }
        return entity;
    }

    @RequestMapping(value = {"list", ""})
    public String list(ReserveVenue reserveVenue, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ReserveVenue> page = reserveVenueService.findPage(new Page<>(request, response), reserveVenue);
        model.addAttribute("page", page);
        return "reserve/venue/list";
    }

    @RequestMapping(value = "form")
    @Token(save = true)
    public String form(ReserveVenue reserveVenue, Model model) {
        model.addAttribute("reserveVenue", reserveVenue);
        return "reserve/venue/form";
    }

    @RequestMapping(value = "save")
    @Token(remove = true)
    public String save(ReserveVenue reserveVenue, AttMainForm attMainForm, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, reserveVenue)) {
            return form(reserveVenue, model);
        }
        reserveVenueService.save(reserveVenue, attMainForm);
        addMessage(redirectAttributes, "保存健身房成功");
        return "redirect:" + Global.getAdminPath() + "/reserve/reserveVenue/list";
    }

    @RequestMapping(value = "delete")
    public String delete(ReserveVenue reserveVenue,RedirectAttributes redirectAttributes) {
        reserveVenueService.delete(reserveVenue);
        addMessage(redirectAttributes, "删除场馆成功");
        return "redirect:" + Global.getAdminPath() + "/reserve/reserveVenue/list";
    }

    @RequestMapping(value = "totalIncomeReport")
    public String totalIncomeReport(HttpServletRequest request,ReserveVenueTotalIntervalReport intervalTotalReport, Model model) {
        String check = request.getParameter("isChecked");
        if("true".equals(check)){
            CheckUtils.saveCheckRecord(request,"totalIncomeReport");
        }
        //检查是否已经审核过
        request.setAttribute("checkStatus",CheckUtils.hasCheckRecord(request,"totalIncomeReport"));
        if(StringUtils.isEmpty(intervalTotalReport.getQueryType())){
            intervalTotalReport.setQueryType("0");//默认流水
        }
        Date startDate=intervalTotalReport.getStartDate();
        Date endDate=intervalTotalReport.getEndDate();
        if(startDate==null){
            intervalTotalReport.setStartDate(new Date());
        }
        if(endDate==null){
            intervalTotalReport.setEndDate(new Date());
        }
        List<ReserveVenue> reserveVenueList=reserveVenueService.findList(new ReserveVenue());//场馆列表

        List<ReserveVenueTotalIntervalReport> totalIntervalReportList=reserveVenueService.totalIncomeReport(intervalTotalReport);
        model.addAttribute("reserveVenueList",reserveVenueList);//场馆列表
        model.addAttribute("intervalTotalReport",intervalTotalReport);//请求参数
        model.addAttribute("totalIntervalReportList",totalIntervalReportList);//返回结果
        return "reserve/report/venueIncomeTotalReport";
    }

    @RequestMapping(value = "fieldReport")
    public String report(ReserveVenueProjectIntervalReport venueProjectReport, @RequestParam(required=false,defaultValue="1",value="queryType") String queryType, Model model) {
        Date startDate=venueProjectReport.getStartDate();
        Date endDate=venueProjectReport.getEndDate();
        venueProjectReport.setReserveVenue(reserveVenueService.get(venueProjectReport.getReserveVenue()));
        if(startDate==null){
            startDate=new Date();//默认当天
            venueProjectReport.setStartDate(startDate);
        }
        if(endDate==null){
            endDate=new Date();//默认当天
            venueProjectReport.setEndDate(endDate);
        }
        ReserveVenueIncomeIntervalReport incomeReport=reserveVenueService.reserveVenueIncomeIntervalReport(venueProjectReport,queryType);//场馆 项目 区间报表
        incomeReport.setStartDate(startDate);
        incomeReport.setEndDate(endDate);
        model.addAttribute("incomeReport",incomeReport);//收入统计
        model.addAttribute("venueProjectReport",venueProjectReport);//查询参数回传
        List<ReserveVenue> reserveVenueList=reserveVenueService.findList(new ReserveVenue());//场馆列表
        model.addAttribute("reserveVenueList",reserveVenueList);//场馆列表
        if("1".equals(queryType)){
            return "reserve/report/venueFieldIncomeReport";
        }else{
            List<ReserveVenueProjectIntervalReport> venueProjectDividedReports = reserveVenueService.reserveVenueProjectDividedIntervalReport(venueProjectReport);//场馆 项目 散客 收入统计
            model.addAttribute("venueProjectDividedReports",venueProjectDividedReports);//查询参数回传
            return "reserve/report/venueFieldIncomeDetailReport";
        }
    }

    @RequestMapping(value = "reportExport")
    public void reportExport(HttpServletResponse response,ReserveVenueProjectIntervalReport venueProjectReport,
                             @RequestParam(required=false,defaultValue="1",value="queryType") String queryType
    )throws Exception {
        Date startDate=venueProjectReport.getStartDate();
        Date endDate=venueProjectReport.getEndDate();
        venueProjectReport.setReserveVenue(reserveVenueService.get(venueProjectReport.getReserveVenue()));
        if(startDate==null){
            startDate=new Date();//默认当天
            venueProjectReport.setStartDate(startDate);
        }
        if(endDate==null){
            endDate=new Date();//默认当天
            venueProjectReport.setEndDate(endDate);
        }
        if(StringUtils.isEmpty(queryType)){
            queryType="1";
        }
        ReserveVenueIncomeIntervalReport incomeReport=reserveVenueService.reserveVenueIncomeIntervalReport(venueProjectReport,queryType);//场馆区间报表
        incomeReport.setStartDate(startDate);
        incomeReport.setEndDate(endDate);
        if("1".equals(queryType)){
            String[] titles = {"健身房","储值卡","现金收入","银行卡收入","微信收入","支付宝收入","欠账","其它","合计"};
            List<String[]> contentList = new ArrayList<>();
            for(ReserveVenueProjectIntervalReport report :incomeReport.getProjectIntervalReports()){
                String[] o = new String[10];
                o[0] = report.getReserveVenue().getName();
                o[2] = String.valueOf(report.getStoredCardBill());
                o[3] = String.valueOf(report.getCashBill());
                o[4] = String.valueOf(report.getBankCardBill());
                o[5] = String.valueOf(report.getWeiXinBill());
                o[6] = String.valueOf(report.getAliPayBill());
                o[7] = String.valueOf(report.getDueBill());
                o[8] = String.valueOf(report.getOtherBill());
                o[9] = String.valueOf(report.getBill());
                contentList.add(o);
            }
            String[] o = new String[10];
            o[0] = "合计";
            o[1] = "";
            o[2] = String.valueOf(incomeReport.getStoredCardBill());
            o[3] = String.valueOf(incomeReport.getCashBill());
            o[4] = String.valueOf(incomeReport.getBankCardBill());
            o[5] = String.valueOf(incomeReport.getWeiXinBill());
            o[6] = String.valueOf(incomeReport.getAliPayBill());
            o[7] = String.valueOf(incomeReport.getDueBill());
            o[8] = String.valueOf(incomeReport.getOtherBill());
            o[9] = String.valueOf(incomeReport.getBill());
            contentList.add(o);
            Date now = new Date();
            ExcelInfo info = new ExcelInfo(response,"场馆收入汇总"+ DateUtils.formatDate(now),titles,contentList);
            info.export();
        }else{
            String[] titles = {"健身房","教练","储值卡","现金收入","银行卡收入","微信收入","支付宝收入","欠账","其它","合计"};
            List<String[]> contentList = new ArrayList<>();
            for(ReserveVenueProjectIntervalReport report :incomeReport.getProjectIntervalReports()){
                for(ReserveVenueProjectFieldIntervalReport field:report.getFieldIntervalReports()){
                    String[] o = new String[11];
                    o[0] = field.getReserveVenue().getName();
                    o[2] = field.getReserveField().getName();
                    o[3] = String.valueOf(field.getStoredCardBill());
                    o[4] = String.valueOf(field.getCashBill());
                    o[5] = String.valueOf(field.getBankCardBill());
                    o[6] = String.valueOf(field.getWeiXinBill());
                    o[7] = String.valueOf(field.getAliPayBill());
                    o[8] = String.valueOf(field.getDueBill());
                    o[9] = String.valueOf(field.getOtherBill());
                    o[10] = String.valueOf(field.getBill());
                    contentList.add(o);
                }
            }
            Date now = new Date();
            ExcelInfo info = new ExcelInfo(response,"健身房收入明细"+ DateUtils.formatDate(now),titles,contentList);
            info.export();
        }
    }
}