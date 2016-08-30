package com.bra.modules.app.service;

import com.bra.common.service.CrudService;
import com.bra.modules.app.dao.AppFieldDao;
import com.bra.modules.reserve.dao.ReserveFieldDao;
import com.bra.modules.reserve.entity.ReserveField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 场地管理Service
 *
 * @author 肖斌
 * @version 2015-12-29
 */
@Service
@Transactional(readOnly = true)
public class AppFieldService extends CrudService<AppFieldDao, ReserveField> {
    @Autowired
    private AppFieldDao dao;

    public ReserveField get(String id) {
        ReserveField reserveField = super.get(id);
        return reserveField;
    }

    public List<ReserveField> findList(ReserveField reserveField) {
        List<ReserveField> list=super.findList(reserveField);
        return list;
    }
}