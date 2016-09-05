package com.bra.modules.app.web;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.bra.common.utils.StringUtils;
import com.bra.common.web.BaseController;
import com.bra.modules.app.service.ReserveAppVenueConsService;
import com.bra.modules.reserve.entity.*;
import com.bra.modules.reserve.entity.form.FieldPrice;
import com.bra.modules.reserve.service.ReserveAppFieldPriceService;
import com.bra.modules.reserve.service.ReserveVenueConsItemService;
import com.bra.modules.reserve.utils.TimeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 场地管理Controller
 *
 * @author jiang
 * @version 2015-12-29
 */
@Controller
@RequestMapping(value = "${adminPath}/app/reserve")
public class AppFieldController extends BaseController {
    @Autowired
    private ReserveAppFieldPriceService reserveAppFieldPriceService;
    @Autowired
    private ReserveAppVenueConsService reserveAppVenueConsService;
    @Autowired
    private ReserveVenueConsItemService reserveVenueConsItemService;

    /**
     *
     * @param consDate 日期
     * @param filedId 教练编号
     * @param model
     * @return
     */
    @RequestMapping(value = "timeList")
    public String main(Date consDate, String filedId,String venueId, Model model) {
        if (consDate == null) {
            consDate = new Date();
        }
        if(StringUtils.isEmpty(filedId)){

        }else {
            List<String> times = new ArrayList<>();
            String startTime = "06:00:00";
            String endTime = "00:00:00";
            times.addAll(TimeUtils.getTimeSpacListValue(startTime, endTime, 30));
            //场地价格
            List<FieldPrice> venueFieldPriceList = reserveAppFieldPriceService.findByDate(consDate, filedId,times);
            model.addAttribute("venueFieldPriceList", venueFieldPriceList);
            model.addAttribute("times", times);
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
            model.addAttribute("consDate", fmt.format(consDate));
            model.addAttribute("filedId",filedId);
            model.addAttribute("venueId",venueId);
        }
        return "app/timeList";
    }

    /**
     * 订单保存
     *
     * @param reserveJson
     * @param projectId
     * @return
     */
    @RequestMapping(value = "reservation")
    @ResponseBody
    public Map reservation(String reserveJson, String projectId) {
        String reserve = reserveJson.replaceAll("&quot;", "\"");
        JSONObject object = JSON.parseObject(reserve);
        String date = (String) object.get("consDate");
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date consDate = null;
        try {
            consDate = format.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        List<Map> list = (List<Map>) object.get("venueConsList");
        List<ReserveVenueConsItem> items = new ArrayList<>();
        for (Map i : list) {
            ReserveVenueConsItem item = new ReserveVenueConsItem();
            ReserveField field = new ReserveField();
            String filedId = (String) i.get("reserveFieldId");
            field.setId(filedId);
            String filedName = (String) i.get("reserveFieldName");
            field.setName(filedName);
            item.setReserveField(field);
            String startTime = (String) i.get("startTime");
            item.setStartTime(startTime);
            String endTime = (String) i.get("endTime");
            item.setEndTime(endTime);
            items.add(item);
        }
        boolean bool = true;//时间段是否可用
        for (ReserveVenueConsItem i : items) {//订单详情
            String startTime = i.getStartTime();
            String endTime = i.getEndTime();
            ReserveField field = i.getReserveField();//场地
            //遍历该日期区间 的场地是否有预订
            bool = reserveVenueConsItemService.checkReserveTime(consDate, field, startTime, endTime);
            if (bool == false) {
                break;//该时间段不能使用，跳出循环
            }
        }
        Map map = new HashMap<>();
        map.put("bool", String.valueOf(bool));
        if (bool == true) {
            ReserveVenueCons reserveVenueCons = new ReserveVenueCons();
            reserveVenueCons.setProject(new ReserveProject(projectId));//该字段用于PC统计项目收入
            String reserveVenueId = (String) object.get("venueId");
            ReserveVenue venue = new ReserveVenue(reserveVenueId);
            reserveVenueCons.setReserveVenue(venue);
            reserveVenueCons.setReserveType(ReserveVenueCons.RESERVATION);//已预定
            reserveVenueCons.setConsDate(consDate);
            reserveVenueCons.setVenueConsList(items);
            reserveAppVenueConsService.saveOrder(reserveVenueCons);//保存预订信息
        }
        return map;
    }
}