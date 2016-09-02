/**
 * Copyright &copy; 2012-2014 <a href="https://github.com.bra.>JeeSite</a> All rights reserved.
 */
package com.bra.modules.app.utils;

import com.bra.common.security.Principal;
import com.bra.common.security.SecurityUtil;
import com.bra.common.utils.CacheUtils;
import com.bra.common.utils.SpringContextHolder;
import com.bra.modules.reserve.dao.ReserveMemberDao;
import com.bra.modules.reserve.entity.ReserveMember;

/**
 * 用户工具类
 *
 * @version 2013-12-05
 */
public class MemberUtils {

    private static ReserveMemberDao reserveMemberDao = SpringContextHolder.getBean(ReserveMemberDao.class);


    public static final String USER_CACHE = "userCache";
    public static final String USER_CACHE_ID_ = "id_";
    public static final String USER_CACHE_LOGIN_NAME_ = "ln";

    /**
     * 根据ID获取用户
     *
     * @param id
     * @return 取不到返回null
     */
    public static ReserveMember get(String id) {
        ReserveMember member = (ReserveMember) CacheUtils.get(USER_CACHE, USER_CACHE_ID_ + id);
        if (member == null) {
            member = reserveMemberDao.get(id);
            if (member == null) {
                return null;
            }
            CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + member.getId(), member);
            CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + member.getMobile(), member);
        }
        return member;
    }

    /**
     * 获取当前用户
     *
     * @return 取不到返回 new User()
     */
    public static ReserveMember getMember() {
        Principal principal = SecurityUtil.getPrincipal();
        if (principal != null) {
            ReserveMember member = get(principal.getId());
            if (member != null) {
                return member;
            }
            return new ReserveMember();
        }
        // 如果没有登录，则返回实例化空的User对象。
        return new ReserveMember();
    }
}
