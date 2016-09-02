package com.bra.modules.app.web;

import com.bra.common.web.BaseController;
import com.bra.modules.reserve.entity.form.FieldPrice;
import com.bra.modules.reserve.service.ReserveAppFieldPriceService;
import com.bra.modules.reserve.utils.TimeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

    /**
     *
     * @param consDate 日期
     * @param filedId 教练编号
     * @param model
     * @return
     */
    @RequestMapping(value = "field")
    public String main(Date consDate, String filedId, Model model) {
        if (consDate == null) {
            consDate = new Date();
        }
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
        return "app/reserveAppField";
    }
}