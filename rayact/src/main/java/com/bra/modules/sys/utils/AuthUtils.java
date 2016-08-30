/**
 * Copyright &copy; 2012-2014 <a href="https://github.com.bra.>JeeSite</a> All rights reserved.
 */
package com.bra.modules.sys.utils;

import com.bra.common.security.Principal;
import com.bra.common.security.SecurityUtil;

/**
 * 用户工具类
 *
 * @version 2013-12-05
 */
public class AuthUtils {
    public static boolean isMobileLogin() {
        Principal principal = SecurityUtil.getPrincipal();
        return principal.isMobileLogin();
    }
}
