package com.bra.modules.reserve.web;

import com.bra.common.web.BaseController;
import com.bra.modules.reserve.entity.ReserveCardStatements;
import com.bra.modules.reserve.entity.ReserveVenue;
import com.bra.modules.reserve.service.ReserveCardStatementsService;
import com.bra.modules.reserve.service.ReserveVenueService;
import com.bra.modules.reserve.utils.AuthorityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * Created by DDT on 2016/4/1.
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve/reserveSellReport")
public class ReserveSellReportController extends BaseController {
    @Autowired
    private ReserveCardStatementsService reserveCardStatementsService;
    @Autowired
    private ReserveVenueService reserveVenueService;

    @RequestMapping(value = "list")
    public String list(Model model, ReserveCardStatements reserveCardStatements) {
        ReserveVenue reserveVenue = reserveCardStatements.getVenue();
        if (reserveVenue != null && reserveVenue.getId() != null && !"".equals(reserveVenue.getId().trim())) {
            if (reserveCardStatements.getSqlMap().get("dsf") == null)
                reserveCardStatements.getSqlMap().put("dsf", " and v.id = '" + reserveVenue.getId() + "'  ");
        } else {
            if (reserveCardStatements.getSqlMap().get("dsf") == null)
                reserveCardStatements.getSqlMap().put("dsf", AuthorityUtils.getDsf("v.id"));
        }
        if (reserveCardStatements.getStartDate() == null || reserveCardStatements.getEndDate() == null) {
            Calendar c = Calendar.getInstance();
            reserveCardStatements.setEndDate(c.getTime());
            Calendar c2 = Calendar.getInstance();
            c2.set(Calendar.HOUR_OF_DAY, 6);
            c2.set(Calendar.MINUTE, 0);
            reserveCardStatements.setStartDate(c2.getTime());
        }
        List<Map<String, Object>> rtn = reserveCardStatementsService.venueIncomeReport(reserveCardStatements);
        ReserveVenue v = new ReserveVenue();
        List<ReserveVenue> list = reserveVenueService.findList(v);
        model.addAttribute("rtn", rtn);
        model.addAttribute("reserveVenueList", list);
        model.addAttribute("reserveCardStatements", reserveCardStatements);
        return "reserve/report/venueIncomeReport";
    }
}
