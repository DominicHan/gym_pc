package com.bra.modules.reserve.web;

import com.bra.common.utils.DateUtils;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.modules.reserve.entity.ReserveCommoditySell;
import com.bra.modules.reserve.entity.ReserveCommodityType;
import com.bra.modules.reserve.entity.ReserveVenue;
import com.bra.modules.reserve.entity.form.ReserveCommodityDayReport;
import com.bra.modules.reserve.entity.form.ReserveCommodityIntervalReport;
import com.bra.modules.reserve.entity.form.ReserveCommoditySellReport;
import com.bra.modules.reserve.service.ReserveCommoditySellService;
import com.bra.modules.reserve.service.ReserveCommodityTypeService;
import com.bra.modules.reserve.service.ReserveVenueService;
import com.bra.modules.reserve.utils.ExcelInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 商品销售主表Controller
 * @author jiangxingqi
 * @version 2016-01-12
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/reserveCommoditySell")
public class ReserveCommoditySellController extends BaseController {

	@Autowired
	private ReserveVenueService reserveVenueService;

	@Autowired
	private ReserveCommodityTypeService reserveCommodityTypeService;

	@Autowired
	private ReserveCommoditySellService reserveCommoditySellService;

	@ModelAttribute
	public ReserveCommoditySell get(@RequestParam(required=false) String id) {
		ReserveCommoditySell entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = reserveCommoditySellService.get(id);
		}
		if (entity == null){
			entity = new ReserveCommoditySell();
		}
		return entity;
	}
	//销售报表
	@RequestMapping(value = {"sellReport", ""})
	public String list(ReserveCommoditySell reserveCommoditySell, Model model) {
		ReserveCommoditySellReport sellReport = reserveCommoditySellService.sellReport(reserveCommoditySell);
		model.addAttribute("sellReport",sellReport);
		return "reserve/commodity/reserveCommoditySellReport";
	}

	/*商品收入统计*/
	@RequestMapping(value = {"commodityIncomeIntervalReport", ""})
	public String reserveCommodityIncomeIntervalReport(ReserveCommodityIntervalReport reserveCommodityIntervalReport,
													   @RequestParam(required = false,defaultValue="1") String queryType
			,Model model){
		List<ReserveVenue> reserveVenueList=reserveVenueService.findList(new ReserveVenue());//场馆列表
		List<ReserveCommodityType> reserveCommodityTypeList=reserveCommodityTypeService.findList(new ReserveCommodityType());//商品类型列表
		Date startDate=reserveCommodityIntervalReport.getStartDate();//开始时间
		Date endDate=reserveCommodityIntervalReport.getEndDate();//结束时间
		reserveCommodityIntervalReport.setReserveCommodityType( reserveCommodityTypeService.get(reserveCommodityIntervalReport.getReserveCommodityType()));
		if(startDate==null){
			startDate=new Date();//默认当天
			reserveCommodityIntervalReport.setStartDate(startDate);
		}
		if(endDate==null){
			endDate=new Date();//默认当天
			reserveCommodityIntervalReport.setEndDate(endDate);
		}
		//场馆参数初始化
		ReserveVenue venue=reserveCommodityIntervalReport.getReserveVenue();
		if(venue==null){
			venue=new ReserveVenue();
		}else if(StringUtils.isNoneEmpty(venue.getId())){
			venue=reserveVenueService.get(venue);
		}
		reserveCommodityIntervalReport.setReserveVenue(venue);
		model.addAttribute("reserveCommodityIntervalReport", reserveCommodityIntervalReport);//查询参数返回
		model.addAttribute("reserveVenueList", reserveVenueList);
		model.addAttribute("reserveCommodityTypeList", reserveCommodityTypeList);

		if("1".equals(queryType)){
			List<ReserveCommodityIntervalReport> incomeCollectReports=reserveCommoditySellService.commodityIncomeCollectReport(reserveCommodityIntervalReport);//收入汇总
			model.addAttribute("incomeCollectReports", incomeCollectReports);
			return "reserve/report/commodityIncomeCollectReport";
		}else if("2".equals(queryType)){
			List<ReserveCommodityIntervalReport> intervalReports=reserveCommoditySellService.reserveCommodityIncomeIntervalReport(reserveCommodityIntervalReport);
			model.addAttribute("intervalReports", intervalReports);
			return "reserve/report/commodityIncomeDetailReport";
		}
		return null;
	}

	/*商品收入统计导出*/
	@RequestMapping(value = {"commodityIncomeIntervalReportExport", ""})
	public void reserveCommodityIncomeIntervalReportExport(HttpServletResponse response,ReserveCommodityIntervalReport reserveCommodityIntervalReport,
														   @RequestParam(required = false,defaultValue="1") String queryType)throws Exception{
		Date startDate=reserveCommodityIntervalReport.getStartDate();//开始时间
		Date endDate=reserveCommodityIntervalReport.getEndDate();//结束时间
		reserveCommodityIntervalReport.setReserveCommodityType( reserveCommodityTypeService.get(reserveCommodityIntervalReport.getReserveCommodityType()));
		if(startDate==null){
			startDate=new Date();//默认当天
			reserveCommodityIntervalReport.setStartDate(startDate);
		}
		if(endDate==null){
			endDate=new Date();//默认当天
			reserveCommodityIntervalReport.setEndDate(endDate);
		}
		//场馆参数初始化
		ReserveVenue venue=reserveCommodityIntervalReport.getReserveVenue();
		if(venue==null){
			venue=new ReserveVenue();
		}else if(StringUtils.isNoneEmpty(venue.getId())){
			venue=reserveVenueService.get(venue);
		}
		reserveCommodityIntervalReport.setReserveVenue(venue);

		if("1".equals(queryType)){
			List<ReserveCommodityIntervalReport> incomeCollectReports=reserveCommoditySellService.commodityIncomeCollectReport(reserveCommodityIntervalReport);//收入汇总
			String[] titles = {"商品类型","储值卡","现金收入","银行卡收入","微信收入","支付宝收入","欠账","其它","合计"};
			List<String[]> contentList = new ArrayList<>();
			for(ReserveCommodityIntervalReport report :incomeCollectReports){
				String[] o = new String[9];
				o[0] = report.getReserveCommodityType().getName();
				o[1] = String.valueOf(report.getStoredCardBill());
				o[2] = String.valueOf(report.getCashBill());
				o[3] = String.valueOf(report.getBankCardBill());
				o[4] = String.valueOf(report.getWeiXinBill());
				o[5] = String.valueOf(report.getAliPayBill());
				o[6] = String.valueOf(report.getDueBill());
				o[7] = String.valueOf(report.getOtherBill());
				o[8] = String.valueOf(report.getBill());
				contentList.add(o);
			}
			Date now = new Date();
			ExcelInfo info = new ExcelInfo(response,reserveCommodityIntervalReport.getReserveVenue().getName()+"商品收入统计"+ DateUtils.formatDate(now),titles,contentList);
			info.export();
		}else if("2".equals(queryType)){
			List<ReserveCommodityIntervalReport> intervalReports=reserveCommoditySellService.reserveCommodityIncomeIntervalReport(reserveCommodityIntervalReport);
			String[] titles = {"日期","商品","储值卡","现金收入","银行卡收入","微信收入","支付宝收入","欠账","其它","合计"};
			List<String[]> contentList = new ArrayList<>();
			for(ReserveCommodityIntervalReport report :intervalReports){
				for(ReserveCommodityDayReport day:report.getDayReportList()){
					String[] dayin = new String[10];
					dayin[0] = DateUtils.formatDate(day.getDay());
					dayin[1] = report.getReserveCommodity().getName();
					dayin[2] = String.valueOf(report.getStoredCardBill());
					dayin[3] = String.valueOf(report.getCashBill());
					dayin[4] = String.valueOf(report.getBankCardBill());
					dayin[5] = String.valueOf(report.getWeiXinBill());
					dayin[6] = String.valueOf(report.getAliPayBill());
					dayin[7] = String.valueOf(report.getDueBill());
					dayin[8] = String.valueOf(report.getOtherBill());
					dayin[9] = String.valueOf(report.getBill());
					contentList.add(dayin);
				}
			}
			Date now = new Date();
			String venueName=reserveCommodityIntervalReport.getReserveVenue().getName();
			if(venueName==null){
				venueName="";
			}
			ExcelInfo info = new ExcelInfo(response,venueName+"商品收入明细"+ DateUtils.formatDate(now),titles,contentList);
			info.export();
		}
	}
}