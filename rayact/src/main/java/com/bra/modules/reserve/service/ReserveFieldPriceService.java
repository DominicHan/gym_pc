package com.bra.modules.reserve.service;

import com.bra.common.utils.StringUtils;
import com.bra.modules.reserve.dao.ReserveFieldPriceSetDao;
import com.bra.modules.reserve.dao.ReserveMemberDao;
import com.bra.modules.reserve.dao.ReserveStoredcardMemberSetDao;
import com.bra.modules.reserve.dao.ReserveVenueConsItemDao;
import com.bra.modules.reserve.entity.*;
import com.bra.modules.reserve.entity.form.FieldPrice;
import com.bra.modules.reserve.entity.form.TimePrice;
import com.bra.modules.reserve.utils.TimeUtils;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by jiangxingqi on 16/1/11.
 */
@Service
@Transactional(readOnly = true)
public class ReserveFieldPriceService {

    @Autowired
    private ReserveTimeIntervalService reserveTimeIntervalService;

    @Autowired
    private ReserveFieldService reserveFieldService;
    @Autowired
    private ReserveFieldPriceSetDao reserveFieldPriceSetDao;
    //预定信息
    @Autowired
    private ReserveVenueConsItemDao reserveVenueConsItemDao;
    @Autowired
    private ReserveMemberDao reserveMemberDao;
    @Autowired
    private ReserveStoredcardMemberSetDao reserveStoredcardMemberSetDao;
    @Autowired
    private ReserveFieldRelationService relationService;
    @Autowired
    private ReserveVenueEmptyCheckService reserveVenueEmptyCheckService;

    public Double getMemberDiscountRate(ReserveMember member) {
        ReserveMember reserveMember = reserveMemberDao.get(member);
        ReserveStoredcardMemberSet set = reserveMember.getStoredcardSet();
        Double rate = null;
        if (set != null) {
            ReserveStoredcardMemberSet storedcardMemberSet = reserveStoredcardMemberSetDao.get(set);
            rate = storedcardMemberSet.getDiscountRate();
        }
        return rate;
    }

    private void setWeek(ReserveFieldPriceSet reserveFieldPriceSet, Date date) {
        String week = TimeUtils.getWeekOfDate(date);
        if ("周六".equals(week)) {//2
            reserveFieldPriceSet.setWeek("2");
        } else if ("周日".equals(week)) {//3
            reserveFieldPriceSet.setWeek("3");
        } else {//1
            reserveFieldPriceSet.setWeek("1");
        }
    }

    public Double getPrice(ReserveField field, String consType, Date date, String startTime, String endTime) {
        List<String> timeList = TimeUtils.getTimeSpace(startTime, endTime);
        String weekType = TimeUtils.getWeekType(date);
        ReserveFieldPriceSet priceSet = new ReserveFieldPriceSet();
        priceSet.setConsType(consType);
        priceSet.setWeek(weekType);
        priceSet.setReserveField(field);
        field=reserveFieldService.get(field);
        //如果场地区分时令，按时令取价格
        if("1".equals(field.getIsTimeInterval())){
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int day = cal.get(Calendar.DATE);
            int month = cal.get(Calendar.MONTH)+1;
            ReserveTimeInterval timeInterval=reserveTimeIntervalService.findTimeInterval(month,day);
            priceSet.setReserveTimeInterval(timeInterval);
        }

        List<ReserveFieldPriceSet> priceSets = reserveFieldPriceSetDao.findList(priceSet);
        Double price = 0d;
        for (String time : timeList) {
            TimePrice tp = timeHasPriceSet(time, priceSets);
            if (tp != null) {
                price += tp.getPrice();
            }
        }
        return price / 2;//因为价格设定时，以一小时为单位，而预订时以半小时为单位，所以除2
    }

    private TimePrice timeHasPriceSet(String time, List<ReserveFieldPriceSet> priceSetList) {
        for (ReserveFieldPriceSet priceSet : priceSetList) {
            List<TimePrice> tpList = priceSet.getTimePriceList();
            for (TimePrice tp : tpList) {
                if (tp.getTime().substring(0, tp.getTime().indexOf(":")).equals(time.substring(0, time.indexOf(":")))) {
                    return tp;
                }
            }
        }
        return null;
    }

    /**
     * 根据场馆Id和时间获取场地不同时间段的价格,并查询当前时间是否预定,并标记位已定
     *
     * @param venueId 场馆Id
     * @param date    时间
     * @param consType 会员类型(1:散客,2:会员)
     * @return
     */
    public List<FieldPrice> findByDate(String venueId, String consType, Date date, List<String> times) {
        List<FieldPrice> fieldPriceList = Lists.newLinkedList();
        //查询场馆中所有场地
        ReserveField field = new ReserveField();
        ReserveVenue venue = new ReserveVenue();
        venue.setId(venueId);
        field.setReserveVenue(venue);
        List<ReserveField> fieldList = reserveFieldService.findList(field);

        //查询已预定的信息
        ReserveVenueConsItem reserveVenueCons = new ReserveVenueConsItem();
        reserveVenueCons.setReserveVenue(new ReserveVenue(venueId));
        reserveVenueCons.setConsDate(date);
        //查询所有预定的信息(作为本场地的预定标记)
        List<ReserveVenueConsItem> venueConsList = reserveVenueConsItemDao.findListByDate(reserveVenueCons);
        //查询已审核的信息
        ReserveVenueEmptyCheck reserveVenueEmptyCheck = new ReserveVenueEmptyCheck();
        reserveVenueEmptyCheck.setVenue(new ReserveVenue(venueId));
        reserveVenueEmptyCheck.setCheckDate(date);
        List<ReserveVenueEmptyCheck> emptyChecks = reserveVenueEmptyCheckService.findList(reserveVenueEmptyCheck);
        //查询价格
        ReserveFieldPriceSet reserveFieldPriceSet = new ReserveFieldPriceSet();
        reserveFieldPriceSet.setReserveVenue(venue);
        setWeek(reserveFieldPriceSet, date);
        //会员类型(1:散客,2:会员)
        if (StringUtils.isNotBlank(consType)) {
            reserveFieldPriceSet.setConsType(consType);
        }
        String weekType = TimeUtils.getWeekType(date);//获得当天属于周几
        reserveFieldPriceSet.setWeek(weekType);
        List<ReserveFieldPriceSet> reserveFieldPriceSetList = new ArrayList<ReserveFieldPriceSet>();
        //设置场地的时令
        for (ReserveField i : fieldList) {
            reserveFieldPriceSet.setReserveField(i);
            List<ReserveFieldPriceSet> list = reserveFieldPriceSetDao.findList(reserveFieldPriceSet);
            reserveFieldPriceSet.setReserveTimeInterval(null);//将时令制空
            reserveFieldPriceSetList.addAll(list);
        }
        buildTimePrice(fieldPriceList, reserveFieldPriceSetList, venueConsList,emptyChecks, times);//获取场地的价格列表，并查询当前时间是否预定,并标记位已定

        return fieldPriceList;
    }

    /**
     * 查询场地的状态
     * @param items
     * @param fieldPriceSet
     * @param time
     * @return
     */
    private ReserveVenueConsItem hasReserve(List<ReserveVenueConsItem> items, ReserveFieldPriceSet fieldPriceSet, String time) {
        for (ReserveVenueConsItem item : items) {
            if (fieldPriceSet.getReserveField().getId().equals(item.getReserveField().getId())) {
                String startTime = item.getStartTime();
                String endTime = item.getEndTime();
                List<String> times = TimeUtils.getTimeSpacListValue(startTime + ":00", endTime + ":00", TimeUtils.BENCHMARK);
                for (String t : times) {
                    if (time.equals(t)) {
                        return item;
                    }
                }
            }
        }
        return null;
    }

    /**
     * 查询场地是否已经通过审核
     * @param checks
     * @param fieldPriceSet
     * @param time
     * @return
     */
    private ReserveVenueEmptyCheck hasCheck(List<ReserveVenueEmptyCheck> checks, ReserveFieldPriceSet fieldPriceSet, String time) {
        for (ReserveVenueEmptyCheck check : checks) {
            if (fieldPriceSet.getReserveField().getId().equals(check.getField().getId())) {
                String startTime = check.getStartTime();
                String endTime = check.getEndTime();
                List<String> times = TimeUtils.getTimeSpacListValue(startTime + ":00", endTime + ":00", TimeUtils.BENCHMARK);
                for (String t : times) {
                    if (time.equals(t)) {
                        return check;
                    }
                }
            }
        }
        return null;
    }

    /**
     *获取场地的时间，价格，状态
     * @param fieldPriceList 场地的时间价格列表
     * @param reserveFieldPriceSetList 场地价格设置
     * @param venueConsList 场馆订单
     * @param reserveVenueEmptyChecks 空场审核
     * @param times 时间表
     */
    private void buildTimePrice(List<FieldPrice> fieldPriceList, List<ReserveFieldPriceSet> reserveFieldPriceSetList,
                                List<ReserveVenueConsItem> venueConsList,List<ReserveVenueEmptyCheck> reserveVenueEmptyChecks, List<String> times) {

        FieldPrice fieldPrice;
        //遍历场地的时间价格列表
        for (ReserveFieldPriceSet fieldPriceSet : reserveFieldPriceSetList) {
            fieldPrice = new FieldPrice();
            ReserveField field = fieldPriceSet.getReserveField();//获取场地
            fieldPrice.setVenueId(fieldPriceSet.getReserveVenue().getId());//设置场馆编号
            fieldPrice.setFieldId(fieldPriceSet.getReserveField().getId());//设置场地编号
            fieldPrice.setFieldName(fieldPriceSet.getReserveField().getName());//设置场地名称
            List<TimePrice> timePriceList = fieldPriceSet.getTimePriceList();//获取一个场地 时间和价格 组成的Jason

            List<TimePrice> priceStatusList=fieldPrice.getTimePriceList();
            //遍历所有时间
            for (String time : times) {
                TimePrice timePrice = new TimePrice();
                timePrice.setTime(time);
                //遍历时间价格组成的Jason
                for (TimePrice tp : timePriceList) {
                    String t = tp.getTime();//获取时间
                    Double price = tp.getPrice();//获取价格
                    String hour = time.substring(0, 2);
                    t = t.substring(0, 2);
                    if (hour.equals(t)) {//时间一致
                        timePrice.setPrice(price);//设置小时价格
                        break;
                    }
                }
                //查询时间time是否已经预定
                ReserveVenueConsItem item = hasReserve(venueConsList, fieldPriceSet, time);
                if (item != null) {//已经预定
                    timePrice.setConsItem(item);//设置订单
                    timePrice.setUserName(item.getConsData().getUserName());//预订人
                    timePrice.setStatus(item.getConsData().getReserveType());//订单状态
                } else {
                    timePrice.setStatus("0");//没有预订
                }
                //查询时间time是否已经通过空场审核
                ReserveVenueEmptyCheck check = hasCheck(reserveVenueEmptyChecks, fieldPriceSet, time);
                if (check != null) {//已经审核
                    timePrice.setCheck(check);//设置审核
                    timePrice.setUserName(check.getCreateBy().getName());//审核人
                    timePrice.setStatus("0"+check.getCheckStatus());//审核状态
                }
                priceStatusList.add(timePrice);
            }
            fieldPriceList.add(fieldPrice);//添加某个场地的所有价格和状态列表
        }
    }
}
