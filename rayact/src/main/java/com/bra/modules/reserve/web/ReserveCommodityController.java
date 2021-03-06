package com.bra.modules.reserve.web;

import com.bra.common.config.Global;
import com.bra.common.persistence.Page;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.common.web.annotation.Token;
import com.bra.modules.reserve.entity.*;
import com.bra.modules.reserve.service.*;
import com.bra.modules.reserve.utils.AuthorityUtils;
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
import java.text.DecimalFormat;
import java.util.List;

/**
 * 商品Controller
 *
 * @author jiangxingqi
 * @version 2016-01-07
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/commodity")
public class ReserveCommodityController extends BaseController {

    @Autowired
    private ReserveCommodityService commodityService;

    @Autowired
    private ReserveVenueService venueService;

    @Autowired
    private ReserveCommodityTypeService reserveCommodityTypeService;

    @Autowired
    private ReserveCommoditySupplierService reserveCommoditySupplierService;

    @Autowired
    private ReserveCommodityStorageLogService reserveCommodityStorageLogService;

    @ModelAttribute
    public ReserveCommodity get(@RequestParam(required = false) String id) {
        ReserveCommodity entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = commodityService.get(id);
        }
        if (entity == null) {
            entity = new ReserveCommodity();
        }
        return entity;
    }

    @RequestMapping(value = {"checkCommodityId", ""})
    @ResponseBody
    public String checkCommodityId(String id,String commodityId) {
        ReserveCommodity uncheckedCommodity=new ReserveCommodity();
        uncheckedCommodity.setCommodityId(commodityId);
        uncheckedCommodity.setId(id);
        List<ReserveCommodity> commodityList=commodityService.checkCommodityId(uncheckedCommodity);
        if(commodityList.size()==0){
            return "available";
        }else{
            return "unavailable";
        }
    }

    @RequestMapping(value = {"list", ""})
    public String list(ReserveCommodity commodity, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ReserveCommodity> page = commodityService.findPage(new Page<ReserveCommodity>(request, response), commodity);
        String userType=AuthorityUtils.getUserType();
        List<ReserveVenue> venues=venueService.findList(new ReserveVenue());
        model.addAttribute("venues", venues);
        model.addAttribute("userType", userType);
        model.addAttribute("page", page);
        model.addAttribute("query", commodity);
        return "reserve/commodity/reserveCommodityList";
    }

    @RequestMapping(value = {"onShelfList", ""})
    @Token(save = true)
    public String sellList(ReserveCommodity commodity, HttpServletRequest request, HttpServletResponse response, Model model) {
        commodity.setShelvesStatus("1");
        Page<ReserveCommodity> page = commodityService.findPage(new Page<ReserveCommodity>(request, response), commodity);
        model.addAttribute("page", page);
        return "reserve/commodity/reserveCommodityOnShelfList";
    }

    @RequestMapping(value = "form")
    @Token(save = true)
    public String form(ReserveCommodity commodity, Model model) {
       if (StringUtils.isNoneEmpty(commodity.getId()) ) {
           commodity = commodityService.get(commodity);
        }
        List<ReserveVenue> venueList=venueService.findList(new ReserveVenue());
        List<ReserveCommodityType> commodityTypeList = reserveCommodityTypeService.findList(new ReserveCommodityType());
        model.addAttribute("commodityTypeList", commodityTypeList);
        model.addAttribute("commodity", commodity);
        model.addAttribute("venueList", venueList);
        return "reserve/commodity/reserveCommodityForm";
    }

    @RequestMapping(value = "inStorageForm")
    @Token(save = true)
    public String inStorageUrl(ReserveCommodity commodity, Model model) {
        commodity = commodityService.get(commodity);
        List<ReserveCommoditySupplier> reserveCommoditySupplierList=reserveCommoditySupplierService.findList(new ReserveCommoditySupplier());
        model.addAttribute("commodity", commodity);
        model.addAttribute("reserveCommoditySupplierList", reserveCommoditySupplierList);
        return "reserve/commodity/reserveCommodityInstorageForm";
    }

    @RequestMapping(value = "inStorage")
    @ResponseBody
    @Token(remove = true)
    public String inStorage(String id, Integer inRepertoryBoxNum,Double boxPrice,String supplierId,String remarks) {
        ReserveCommodity commodity = new ReserveCommodity();
        commodity.setId(id);
        commodity=commodityService.get(commodity);
        int repertoryNumBefore = commodity.getRepertoryNum();//入库前的库存
        int num= inRepertoryBoxNum*commodity.getUnit();
        int repertoryNumAfter =repertoryNumBefore+num;//入库后的库存
        commodity.setRepertoryNum(repertoryNumAfter);
        commodityService.save(commodity);

        ReserveCommodityStorageLog log=new ReserveCommodityStorageLog();
        ReserveCommoditySupplier reserveCommoditySupplier =new ReserveCommoditySupplier(supplierId);
        log.setReserveCommoditySupplier(reserveCommoditySupplier);
        log.setReserveCommodity(commodity);
        log.setReserveVenue(commodity.getReserveVenue());
        log.setBoxNum(inRepertoryBoxNum);
        log.setBoxPrice(boxPrice);
        Double price=boxPrice/commodity.getUnit();
        DecimalFormat df=new DecimalFormat("0.00");
        price=new Double(df.format(price).toString());
        log.setPrice(price);
        log.setNum(num);
        log.setAfterNum(repertoryNumAfter);
        log.setBeforeNum(repertoryNumBefore);
        log.setRemarks(remarks);
        reserveCommodityStorageLogService.save(log);
        return "success";
    }

    @RequestMapping(value = "save")
    @Token(remove = true)
    public String save(ReserveCommodity commodity, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, commodity)) {
            return form(commodity, model);
        }
        commodityService.save(commodity);
        addMessage(redirectAttributes, "保存商品成功");
        return "redirect:" + Global.getAdminPath() + "/reserve/commodity/list";
    }

    @RequestMapping(value = "delete")
    public String delete(ReserveCommodity commodity, RedirectAttributes redirectAttributes) {
        commodityService.delete(commodity);
        addMessage(redirectAttributes, "删除商品成功");
        return "redirect:" + Global.getAdminPath() + "/reserve/commodity/list";
    }

}