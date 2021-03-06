package com.bra.modules.reserve.web;

import com.bra.common.config.Global;
import com.bra.common.persistence.Page;
import com.bra.common.utils.DateUtils;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.common.web.annotation.Token;
import com.bra.modules.reserve.entity.*;
import com.bra.modules.reserve.service.*;
import com.bra.modules.reserve.utils.ExcelInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 商品销售明细Controller
 * @author jiangxingqi
 * @version 2016-01-12
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/reserveCommoditySellDetail")
public class ReserveCommoditySellDetailController extends BaseController {

	@Autowired
	private ReserveCommodityService reserveCommodityService;

	@Autowired
	private ReserveCommoditySellDetailService reserveCommoditySellDetailService;

	@Autowired
	private ReserveCommoditySellService reserveCommoditySellService;

	@Autowired
	private ReserveMemberService reserveMemberService;

	@Autowired
	private ReserveCardStatementsService reserveCardStatementsService;

	@Autowired
	private ReserveVenueService reserveVenueService;

	@ModelAttribute
	public ReserveCommoditySellDetail get(@RequestParam(required=false) String id) {
		ReserveCommoditySellDetail entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = reserveCommoditySellDetailService.get(id);
		}
		if (entity == null){
			entity = new ReserveCommoditySellDetail();
		}
		return entity;
	}

	@RequestMapping(value = "settlement")
	@Token(save = true)
	public  String settlement(ReserveCommoditySellDetailList sellDetailList, Model model) {
		ReserveMember rm=new ReserveMember();
		List<ReserveMember> reserveMemberList=reserveMemberService.findList(rm);
		model.addAttribute("reserveMemberList",reserveMemberList);
		model.addAttribute("sellDetailList",sellDetailList.getReserveCommoditySellDetailList());
		return "reserve/commodity/reserveCommodityPayForm";
	}

	@RequestMapping(value = "paySubmit")
	@ResponseBody
	@Token(remove = true)
	public  String paySubmit(ReserveCommoditySellDetailList sellDetailList) {
		//销售主表
		Double total=0.0;
		String payType=sellDetailList.getPayType();
		for(ReserveCommoditySellDetail sellDetail:sellDetailList.getReserveCommoditySellDetailList() ){
			Double detailSum=sellDetail.getDetailSum();
			total+=detailSum;
		}
		ReserveCommoditySell reserveCommoditySell=new ReserveCommoditySell();
		reserveCommoditySell.setTotalSum(total);
		reserveCommoditySell.setGiftFlag("0");
		reserveCommoditySell.setPayType(payType);
		ReserveMember reserveMember=sellDetailList.getReserveStoredCardMember();
		if(reserveMember!=null){
			reserveMember=reserveMemberService.get(reserveMember);
		}
		reserveCommoditySell.setReserveMember(reserveMember);
		reserveCommoditySellService.save(reserveCommoditySell);

		String sellId=reserveCommoditySell.getId();
		String remarks="";
		//销售明细表
		for(ReserveCommoditySellDetail sellDetail:sellDetailList.getReserveCommoditySellDetailList() ){
			Integer num=sellDetail.getNum();
			ReserveCommodity commodity=sellDetail.getReserveCommodity();//买的啥
			sellDetail.setReserveMember(reserveMember);//谁买的
			sellDetail.setReserveCommoditySell(reserveCommoditySell);
			commodity=reserveCommodityService.get(commodity);
			int repertoryNum=commodity.getRepertoryNum();
			repertoryNum-=num;//商品出库
			remarks+=commodity.getName()+" "+num+"个;";
			commodity.setRepertoryNum(repertoryNum);
			reserveCommodityService.save(commodity);
			reserveCommoditySellDetailService.save(sellDetail);
			ReserveCardStatements reserveCardStatements=new ReserveCardStatements();
			reserveCardStatements.setReserveCommodity(commodity);
			reserveCardStatements.setVenue(commodity.getReserveVenue());
			reserveCardStatements.setReserveMember(reserveMember);
			reserveCardStatements.setTransactionType("3");//3代表商品消费
			reserveCardStatements.setTransactionNum(num);//交易量
			reserveCardStatements.setPayType(payType);
			reserveCardStatements.setRemarks("商品消费");
			reserveCardStatements.setTransactionVolume(sellDetail.getDetailSum());//消费额
			reserveCardStatementsService.save(reserveCardStatements);
		}
		if("1".equals(payType)){// 1代表会员,变更会员余额
			reserveMember.setRemainder(reserveMember.getRemainder()-total);
			reserveMemberService.save(reserveMember);
			ReserveCardStatements reserveCardStatements=new ReserveCardStatements();
			reserveCardStatements.setVenue(reserveMember.getReserveVenue());
			reserveCardStatements.setReserveMember(reserveMember);//记录购买人，同时记录余额
			reserveCardStatements.setTransactionType("33");//33代表商品消费汇总
			reserveCardStatements.setPayType(payType);
			reserveCardStatements.setRemarks(remarks);
			reserveCardStatements.setTransactionVolume(total);//消费额
			reserveCardStatementsService.save(reserveCardStatements);
		}
		return sellId;
	}

	@RequestMapping(value = {"list", ""})
	public String list(ReserveCommoditySellDetail reserveCommoditySellDetail, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ReserveCommoditySellDetail> page = reserveCommoditySellDetailService.findPage(new Page<ReserveCommoditySellDetail>(request, response), reserveCommoditySellDetail);
		model.addAttribute("page", page);
		return "reserve/record/reserveCommoditySellDetailList";
	}

	@RequestMapping(value = {"findSellDetailList", ""})
	public String findSellDetailList(ReserveCommoditySellDetail reserveCommoditySellDetail, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<ReserveVenue> venueList=reserveVenueService.findList(new ReserveVenue());
		Page<ReserveCommoditySellDetail> page = reserveCommoditySellDetailService.findSellDetailList(new Page<ReserveCommoditySellDetail>(request, response), reserveCommoditySellDetail);
		model.addAttribute("page", page);
		model.addAttribute("search", reserveCommoditySellDetail);
		model.addAttribute("venueList", venueList);
		return "reserve/record/reserveCommoditySellDetailList";
	}

	@RequestMapping(value = {"findSellDetailListExport", ""})
	public void findSellDetailListExport(ReserveCommoditySellDetail reserveCommoditySellDetail, HttpServletResponse response)throws Exception {
		List<ReserveCommoditySellDetail> list = reserveCommoditySellDetailService.findSellDetailList(reserveCommoditySellDetail);
		String[] titles = {"商品名称","商品类型","购买数量","单价","合计","售卖人","场馆","时间","备注"};
		List<String[]> contentList = new ArrayList<>();
		for(ReserveCommoditySellDetail map :list){
			String[] o = new String[9];
			o[0] = map.getReserveCommodity().getName();
			o[1] = map.getReserveCommodity().getCommodityType().getName();
			o[2] = String.valueOf(map.getNum());
			o[3] = String.valueOf(map.getPrice());
			o[4] =  String.valueOf(map.getDetailSum());
			o[5] =  map.getUpdateBy().getName();
			o[6] =  map.getReserveCommodity().getReserveVenue().getName();
			o[7] =  DateUtils.formatDate(map.getCreateDate(),"yyyy-MM-dd HH:mm:ss");
			o[8] =  String.valueOf(map.getRemarks());
			contentList.add(o);
		}
		Date now = new Date();
		ExcelInfo info = new ExcelInfo(response,"商品销售记录 导出时间："+ DateUtils.formatDate(now),titles,contentList);
		info.export();
	}

	@RequestMapping(value = "form")
	@Token(save = true)
	public String form(ReserveCommoditySellDetail reserveCommoditySellDetail, Model model) {
		model.addAttribute("reserveCommoditySellDetail", reserveCommoditySellDetail);
		return "reserve/commodity/reserveCommoditySellDetailForm";
	}

	@RequestMapping(value = "save")
	@Token(remove = true)
	public String save(ReserveCommoditySellDetail reserveCommoditySellDetail, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, reserveCommoditySellDetail)){
			return form(reserveCommoditySellDetail, model);
		}
		reserveCommoditySellDetailService.save(reserveCommoditySellDetail);
		addMessage(redirectAttributes, "保存商品销售明细成功");
		return "redirect:"+Global.getAdminPath()+"/reserve/reserveCommoditySellDetail/?repage";
	}

	@RequestMapping(value = "delete")
	public String delete(ReserveCommoditySellDetail reserveCommoditySellDetail, RedirectAttributes redirectAttributes) {
		reserveCommoditySellDetailService.delete(reserveCommoditySellDetail);
		addMessage(redirectAttributes, "删除商品销售明细成功");
		return "redirect:"+Global.getAdminPath()+"/reserve/reserveCommoditySellDetail/?repage";
	}

}