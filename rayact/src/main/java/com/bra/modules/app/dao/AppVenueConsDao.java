package com.bra.modules.app.dao;

import com.bra.common.persistence.CrudDao;
import com.bra.common.persistence.annotation.MyBatisDao;
import com.bra.modules.reserve.entity.ReserveVenueCons;

import java.util.List;
import java.util.Map;

/**
 * 场地预定主表DAO接口
 *
 * @author 肖斌
 * @version 2016-01-11
 */
@MyBatisDao
public interface AppVenueConsDao extends CrudDao<ReserveVenueCons> {
    /*订单详情*/
    Map detail(Map map);
    /*订单列表*/
    List<Map> orderList(Map map);
}