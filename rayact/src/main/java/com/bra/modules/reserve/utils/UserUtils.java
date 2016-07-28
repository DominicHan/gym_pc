package com.bra.modules.reserve.utils;

/**
 * Created by jiangxingqi on 16/1/20.
 */
public class UserUtils {
    public static String getUserType(String userType){
        if ("1".equals(userType)) {
            return "超级管理员";
        } else if ("2".equals(userType)) {
            return "场馆管理员";
        } else if ("3".equals(userType)) {
            return "高管";
        } else if ("4".equals(userType)) {
            return "收银";
        } else if ("5".equals(userType)) {
            return "财务";
        } else if ("6".equals(userType)) {
            return "出纳";
        } else if ("7".equals(userType)) {
            return "教练";
        }
        return "";
    }
}
