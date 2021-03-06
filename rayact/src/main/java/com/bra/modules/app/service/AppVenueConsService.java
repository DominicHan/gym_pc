package com.bra.modules.app.service;

import com.bra.common.service.CrudService;
import com.bra.modules.app.dao.AppVenueConsDao;
import com.bra.modules.app.dao.AppVenueConsItemDao;
import com.bra.modules.app.utils.MemberUtils;
import com.bra.modules.reserve.entity.ReserveMember;
import com.bra.modules.reserve.entity.ReserveVenueCons;
import com.bra.modules.reserve.entity.ReserveVenueConsItem;
import com.bra.modules.reserve.service.ReserveFieldPriceService;
import com.bra.modules.reserve.utils.TimeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 场地预定主表Service
 *
 * @author 肖斌
 * @version 2016-01-11
 */
@Service
@Transactional(readOnly = true)
public class AppVenueConsService extends CrudService<AppVenueConsDao, ReserveVenueCons> {


    @Autowired
    private AppVenueConsItemDao appVenueConsItemDao;
    @Autowired
    private AppVenueConsDao appVenueConsDao;
    @Autowired
    private ReserveFieldPriceService reserveFieldPriceService;

    /**
     * 订单详情
     *
     * @param orderId 订单编号
     * @return
     */
    public Map detail(String orderId) {
        Map map = new HashMap<>();
        map.put("orderId", orderId);
        Map order = appVenueConsDao.detail(map);
        if (order != null) {
            List<Map> itemList = appVenueConsItemDao.orderItemList(map);
            order.put("itemList", itemList);
        }
        return order;
    }

    /**
     * 订单列表
     *
     * @param reserveType 订单状态 1:已预订 4：已结算
     * @return
     */
    public List<Map> orderList(String reserveType, String memberId) {
        Map map = new HashMap<>();
        map.put("reserveType", reserveType);
        map.put("memberId", memberId);
        List<Map> orderList = appVenueConsDao.orderList(map);
        for (Map i : orderList) {
            String orderId = (String) i.get("orderId");
            Map m = new HashMap<>();
            m.put("orderId", orderId);
            List<Map> itemList = appVenueConsItemDao.orderItemList(m);
            i.put("itemList", itemList);
        }
        return orderList;
    }

    /**
     * 存储预定单据
     *
     * @param reserveVenueCons
     */
    @Transactional(readOnly = false)
    public void saveOrder(ReserveVenueCons reserveVenueCons) {
        //获取会员
        ReserveMember member = MemberUtils.getMember();
        reserveVenueCons.setMember(member);
        reserveVenueCons.setUserName(member.getName());
        reserveVenueCons.setConsMobile(member.getMobile());
        reserveVenueCons.setConsType("2");//会员
        reserveVenueCons.preInsert();//生成主键
        List<ReserveVenueConsItem> itemList = reserveVenueCons.getVenueConsList();//订单的所有明细
        Double filedSum = 0D;//场地应收
        Date consDate = reserveVenueCons.getConsDate();//预订日期
        String consWeek = TimeUtils.getWeekOfDate(consDate);//周次
        for (ReserveVenueConsItem item : itemList) {
            item.setConsDate(consDate);//预订时间
            item.setReserveVenue(reserveVenueCons.getReserveVenue());//订单详情保存场馆
            item.setConsData(reserveVenueCons);//订单
            item.setConsWeek(consWeek);//设置周次
            item.setFrequency("1");//设置频率
            item.setPeriodNum(0.5);//微信一个单元是半个小时
            // "1"代表门市价 在门市价的基础上进行打折
            Double price = reserveFieldPriceService.getPrice(item.getReserveField(), "1", reserveVenueCons.getConsDate(), item.getStartTime(), item.getEndTime());
            //获取折扣比率
            Double rate = reserveFieldPriceService.getMemberDiscountRate(member);
            if (rate != null && rate != 0) {
                price = price * rate * 0.01;
            }
            item.setOrderPrice(price);//订单明细 场地应收
            filedSum += price;
            item.setConsPrice(price);//订单明细 应收金额=场地应收+教练费
            item.preInsert();
            appVenueConsItemDao.insert(item);//保存预订信息
        }
        reserveVenueCons.setByPC("0");//通过APP预订的
        reserveVenueCons.setPeriodCnt(itemList.size()*0.5);//微信一个单元是半个小时
        reserveVenueCons.setOrderPrice(filedSum);//场地应收金额
        reserveVenueCons.setShouldPrice(filedSum);//订单应收
        appVenueConsDao.insert(reserveVenueCons);//订单价格更改
    }
}