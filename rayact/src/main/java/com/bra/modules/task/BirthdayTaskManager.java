package com.bra.modules.task;

import com.bra.modules.oa.service.OaNotifyService;
import com.bra.modules.reserve.entity.OaNotify;
import com.bra.modules.reserve.entity.ReserveField;
import com.bra.modules.reserve.entity.ReserveMember;
import com.bra.modules.reserve.service.ReserveFieldService;
import com.bra.modules.reserve.service.ReserveMemberService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by lenovo on 2016/6/9.
 */
public class BirthdayTaskManager {
    @Autowired
    private ReserveFieldService reserveFieldService;
    @Autowired
    private ReserveMemberService reserveMemberService;
    @Autowired
    private OaNotifyService oaNotifyService;

    public void birthdayNotify() {
        List<ReserveField> list = reserveFieldService.findList(new ReserveField());
        List<ReserveMember> memberList=reserveMemberService.findList(new ReserveMember());
        for (ReserveField i : list) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            int nowDay = calendar.get(Calendar.DAY_OF_YEAR);
            calendar.setTime(i.getBirthday());
            int birthday = calendar.get(Calendar.DAY_OF_YEAR);
            if (birthday == nowDay) {
                OaNotify oaNotify = new OaNotify();
                oaNotify.setTenantId(i.getTenantId());
                oaNotify.setType("1");//生日提醒
                oaNotify.setStatus("1");//发布
                oaNotify.setTitle(i.getName()+"生日提醒");
                oaNotify.setContent("今天是" + i.getName() + "的生日，大家祝他生日快乐");
                oaNotifyService.oaNotifyAllUser(oaNotify);
            }
        }
        for (ReserveMember j : memberList) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            int nowDay = calendar.get(Calendar.DAY_OF_YEAR);
            calendar.setTime(j.getBirthday());
            int birthday = calendar.get(Calendar.DAY_OF_YEAR);
            if (birthday == nowDay) {
                OaNotify oaNotify = new OaNotify();
                oaNotify.setTenantId(j.getTenantId());
                oaNotify.setType("1");//生日提醒
                oaNotify.setStatus("1");//发布
                oaNotify.setTitle(j.getName()+"生日提醒");
                oaNotify.setContent("今天是" + j.getName() + "的生日，大家祝他生日快乐");
                oaNotifyService.oaNotifyAllUser(oaNotify);
            }
        }
    }
}
