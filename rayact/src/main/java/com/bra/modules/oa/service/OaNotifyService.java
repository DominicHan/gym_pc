/**
 * Copyright &copy; 2012-2014 <a href="https://github.com.bra.>JeeSite</a> All rights reserved.
 */
package com.bra.modules.oa.service;

import com.bra.common.persistence.Page;
import com.bra.common.service.CrudService;
import com.bra.common.utils.IdGen;
import com.bra.modules.oa.dao.OaNotifyDao;
import com.bra.modules.oa.dao.OaNotifyRecordDao;
import com.bra.modules.reserve.entity.OaNotify;
import com.bra.modules.reserve.entity.OaNotifyRecord;
import com.bra.modules.reserve.service.ReserveUserService;
import com.bra.modules.sys.entity.Office;
import com.bra.modules.sys.entity.User;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 通知通告Service
 *
 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class OaNotifyService extends CrudService<OaNotifyDao, OaNotify> {

	@Autowired
	private OaNotifyRecordDao oaNotifyRecordDao;

	@Autowired
	private ReserveUserService reserveUserService;

	public OaNotify get(String id) {
		OaNotify entity = dao.get(id);
		return entity;
	}
	
	/**
	 * 获取通知发送记录
	 * @param oaNotify
	 * @return
	 */
	public OaNotify getRecordList(OaNotify oaNotify) {
		oaNotify.setOaNotifyRecordList(oaNotifyRecordDao.findList(new OaNotifyRecord(oaNotify)));
		return oaNotify;
	}
	
	public Page<OaNotify> find(Page<OaNotify> page, OaNotify oaNotify) {
		oaNotify.setPage(page);
		page.setList(dao.findList(oaNotify));
		return page;
	}
	
	/**
	 * 获取通知数目
	 * @param oaNotify
	 * @return
	 */
	public Long findCount(OaNotify oaNotify) {
		return dao.findCount(oaNotify);
	}
	
	@Transactional(readOnly = false)
	public void save(OaNotify oaNotify) {
		super.save(oaNotify);
		// 更新发送接受人记录
		oaNotifyRecordDao.deleteByOaNotifyId(oaNotify.getId());
		oaNotifyAllUser(oaNotify);
	}
	@Transactional(readOnly = false)
	public void oaNotifyAllUser(OaNotify oaNotify) {
		super.save(oaNotify);
		List<OaNotifyRecord> oaNotifyRecordList = Lists.newArrayList();
		User u=new User();
		u.setCompany(new Office(oaNotify.getTenantId()));
		List<User> reserveUserList = reserveUserService.findList(u);
		for(User user:reserveUserList){
			OaNotifyRecord entity = new OaNotifyRecord();
			entity.setId(IdGen.uuid());
			entity.setOaNotify(oaNotify);
			entity.setUser(user);
			entity.setReadFlag("0");
			oaNotifyRecordList.add(entity);
		}
		if (oaNotifyRecordList.size() > 0){
			oaNotifyRecordDao.insertAll(oaNotifyRecordList);
		}
	}

	
	/**
	 * 更新阅读状态
	 */
	@Transactional(readOnly = false)
	public void updateReadFlag(OaNotify oaNotify) {
		OaNotifyRecord oaNotifyRecord = new OaNotifyRecord(oaNotify);
		oaNotifyRecord.setUser(oaNotifyRecord.getCurrentUser());
		oaNotifyRecord.setReadDate(new Date());
		oaNotifyRecord.setReadFlag("1");
		oaNotifyRecordDao.update(oaNotifyRecord);
	}
}