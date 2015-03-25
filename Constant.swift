//
//  Constant.swift
//  YYB
//
//  Created by zxinc on 15-3-19.
//  Copyright (c) 2015年 zxinc. All rights reserved.
//

import Foundation

var mainUrl = "http://192.168.0.106:8080/api/services/"

//分页页容量
var PAGE_SIZE = 5;
//起始页码
var PAGE_INDEX = 1;
//查询值为空
var IS_NUll = "Q001";
//数据为空
var DATA_NULL = "Q002";
//参数错误
var PARAM_ERROR = "E001";
//参数为空
var PARAM_NULL = "E002";
//操作失败
var OPER_FAIL = "O001";
//操作成功
var OPER_SUCCESS = "O002";
//不合法的电话号码
var ERROR_PHONE = "E003";
//密码过短
var PASSWORD_TOO_SHORT = "E004";
//手机号已注册
var PHONE_IS_EXIST = "E005";
//账号不存在
var ACCOUNT_ERROR = "E006";
//登录成功
var LOGIN_SUCCESS = "S001";
//密码错误
var LOGIN_FAIL_PASSWORD_ERROR = "E007";