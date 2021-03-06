/**
 * Copyright &copy; 2012-2014 <a href="https://github.com.bra.>JeeSite</a> All rights reserved.
 */
package com.bra.modules.sys.web;

import com.bra.common.config.Global;
import com.bra.common.security.Principal;
import com.bra.common.security.SecurityUtil;
import com.bra.common.security.shiro.session.SessionDAO;
import com.bra.common.servlet.ValidateCodeServlet;
import com.bra.common.utils.*;
import com.bra.common.web.BaseController;
import com.bra.modules.reserve.entity.ReserveRole;
import com.bra.modules.reserve.service.ReserveRoleService;
import com.bra.modules.reserve.utils.AuthorityUtils;
import com.bra.modules.sys.entity.User;
import com.bra.modules.sys.security.FormAuthenticationFilter;
import com.bra.modules.sys.service.SystemService;
import com.bra.modules.sys.utils.UserUtils;
import com.google.common.collect.Maps;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 登录Controller
 *
 * @version 2013-5-31
 */
@Controller
public class LoginController extends BaseController {

    public static List<Map<String, String>> users = new ArrayList<>();

    @Autowired
    private SessionDAO sessionDAO;

    /**
     * 登录页面
     */
    @RequestMapping(value = "${adminPath}/appLogin", method = RequestMethod.GET)
    public String weixinLogin(HttpServletResponse response) {
        Principal principal = SecurityUtil.getPrincipal();
        if (logger.isDebugEnabled()) {
            logger.debug("login, active session size: {}", sessionDAO.getActiveSessions(false).size());
        }

        // 如果已登录，再次访问主页，则退出原账号。
        if (Global.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
            CookieUtils.setCookie(response, "LOGINED", "false");
        }

        // 如果已经登录，则跳转到管理首页
        if (principal != null && !principal.isMobileLogin()) {
            return "redirect:" + adminPath;
        }
        return "app/appLogin";
    }

    /**
     * 登录页面
     */
    @RequestMapping(value = "${adminPath}/login", method = RequestMethod.GET)
    public String login(HttpServletResponse response) {
        Principal principal = SecurityUtil.getPrincipal();
        if (logger.isDebugEnabled()) {
            logger.debug("login, active session size: {}", sessionDAO.getActiveSessions(false).size());
        }

        // 如果已登录，再次访问主页，则退出原账号。
        if (Global.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
            CookieUtils.setCookie(response, "LOGINED", "false");
        }

        // 如果已经登录，则跳转到管理首页
        if (principal != null && !principal.isMobileLogin()) {
            return "redirect:" + adminPath;
        }
        return "modules/sys/sysLogin";
    }

    /**
     * 登录失败，真正登录的POST请求由Filter完成
     */
    @RequestMapping(value = "${adminPath}/login", method = RequestMethod.POST)
    public String loginFail(HttpServletRequest request, HttpServletResponse response, Model model) {
        Principal principal = SecurityUtil.getPrincipal();

        // 如果已经登录，则跳转到管理首页
        if (principal != null) {
            return "redirect:" + adminPath;
        }

        String username = WebUtils.getCleanParam(request, FormAuthenticationFilter.DEFAULT_USERNAME_PARAM);
        boolean rememberMe = WebUtils.isTrue(request, FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM);
        boolean mobile = WebUtils.isTrue(request, FormAuthenticationFilter.DEFAULT_MOBILE_PARAM);
        String exception = (String) request.getAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
        String message = (String) request.getAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM);

        if (StringUtils.isBlank(message) || StringUtils.equals(message, "null")) {
            message = "用户或密码错误, 请重试.";
        }
        if (logger.isDebugEnabled()) {
            logger.debug("login fail, active session size: {}, message: {}, exception: {}",
                    sessionDAO.getActiveSessions(false).size(), message, exception);
        }

        // 非授权异常，登录失败，验证码加1。
        if (!UnauthorizedException.class.getName().equals(exception)) {
            model.addAttribute("isValidateCodeLogin", isValidateCodeLogin(username, true, false));
        }

        // 验证失败清空验证码
        request.getSession().setAttribute(ValidateCodeServlet.VALIDATE_CODE, IdGen.uuid());


        model.addAttribute(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM, username);
        model.addAttribute(FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM, rememberMe);
        model.addAttribute(FormAuthenticationFilter.DEFAULT_MOBILE_PARAM, mobile);
        model.addAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME, exception);
        model.addAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM, message);
        // 如果是手机登录，则返回JSON字符串
        if (mobile) {
            return "app/appLogin";
        }
        return "modules/sys/sysLogin";
    }

    /**
     * 登录成功，进入管理首页
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "${adminPath}")
    public String index(HttpServletRequest request, HttpServletResponse response) {
        Principal principal = SecurityUtil.getPrincipal();
        //pc端登陆
        if (principal.isMobileLogin()==false) {
            boolean isLogin = false;
            for (Map<String, String> u : users) {
                if (principal.getId().equals(u.get("userId"))) {
                    isLogin = true;
                }
            }
            User admin = SpringContextHolder.getBean(SystemService.class).getUser(principal.getId());//管理员不记录
            if ("1".equals(admin.getUserType())) {
                isLogin = true;
            }
            if (!isLogin) {
                ReserveRoleService reserveRoleService = SpringContextHolder.getBean("reserveRoleService");
                ReserveRole reserveRole = new ReserveRole();
                reserveRole.setUser(UserUtils.getUser());
                List<String> venueIds = reserveRoleService.findVenueIdsByRole(reserveRole);
                String ids = "";
                for (String v : venueIds) {
                    ids += v;
                }
                Map<String, String> user = new HashMap<>();
                user.put("sid", request.getSession().getId());
                user.put("userId", principal.getId());
                user.put("userName", principal.getName());
                user.put("venuesId", ids);
                user.put("mobile", admin.getPhone());
                users.add(user);
            }

            // 登录成功后，验证码计算器清零
            isValidateCodeLogin(principal.getLoginName(), false, true);

            if (logger.isDebugEnabled()) {
                logger.debug("show index, active session size: {}", sessionDAO.getActiveSessions(false).size());
            }

            // 如果已登录，再次访问主页，则退出原账号。
            if (Global.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
                String logined = CookieUtils.getCookie(request, "LOGINED");
                if (StringUtils.isBlank(logined) || "false".equals(logined)) {
                    CookieUtils.setCookie(response, "LOGINED", "true");
                } else if (StringUtils.equals(logined, "true")) {
                    UserUtils.getSubject().logout();
                    return "redirect:" + adminPath + "/login";
                }
            }
            if ("4".equals(AuthorityUtils.getUserType())) {//营业员
                return "redirect:" + adminPath + "/reserve/salesMain";
            }
            if ("3".equals(AuthorityUtils.getUserType())) {//高管
                request.getSession().setAttribute("alone", "true");
                return "redirect:" + adminPath + "/reserve/reserveListener/report?alone=true";
            }
            return "redirect:" + adminPath + "/reserve/main";
        }else{
            return"redirect:" + adminPath + "/app/main";
        }
    }

    /**
     * 是否是验证码登录
     *
     * @param useruame 用户名
     * @param isFail   计数加1
     * @param clean    计数清零
     * @return
     */
    @SuppressWarnings("unchecked")
    public static boolean isValidateCodeLogin(String useruame, boolean isFail, boolean clean) {
        Map<String, Integer> loginFailMap = (Map<String, Integer>) CacheUtils.get("loginFailMap");
        if (loginFailMap == null) {
            loginFailMap = Maps.newHashMap();
            CacheUtils.put("loginFailMap", loginFailMap);
        }
        Integer loginFailNum = loginFailMap.get(useruame);
        if (loginFailNum == null) {
            loginFailNum = 0;
        }
        if (isFail) {
            loginFailNum++;
            loginFailMap.put(useruame, loginFailNum);
        }
        if (clean) {
            loginFailMap.remove(useruame);
        }
        return loginFailNum >= 3;
    }
}
