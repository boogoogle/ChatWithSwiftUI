//
//  DeviceDefine.swift
//  QWScreenReplay
//
//  Created by xdw on 2020/5/11.
//  Copyright © 2020 xdw. All rights reserved.
//

import Foundation
import UIKit

/** 屏幕宽度 */
let MAINWIDTH = UIScreen.main.bounds.size.width
/** 屏幕高度 */
let MAINHEIGHT = UIScreen.main.bounds.size.height
/** iPhone X取的高度比例 */
let XHEIGHT = (MAINHEIGHT / (IS_IPHONE_X ? 718.3 : 667.0))
/** 屏幕宽度比例 */
let SC_WIDTH  = MAINWIDTH / 375.0
/** 屏幕高度比例 */
let SC_HEIGHT = MAINHEIGHT / 667.0
/** 手机型号 */
let PHONE_MODEL = UIDevice.current.model
/** iPhone X */
let FACEID_ENABLE = kStatusBarHeight > 20 ? true: false
/** 系统版本浮点型 */
let IOS_VERSION = Float(UIDevice.current.systemVersion)
/** 系统版本字符串 */
let CurrentSystemVersion = UIDevice.current.systemVersion
/** 判断是否为iPhone5 */
let IS_IPHONE_5 = MAINWIDTH == 320.0
/** 判断是否为iPhone6 */
let IS_IPHONE_6 = MAINWIDTH == 375.0
/** 判断是否为Plus */
let IS_IPHONE_PLUS = MAINWIDTH == 414.0
/** 判断是否为iPhoneX */
let IS_IPHONE_X = kStatusBarHeight > 20 ? true: false
/** 根据ip6的屏幕来拉伸 */
let FoneScaleAdapter = CGFloat(MAINWIDTH / 375.0)
/** 根据ip6的屏幕来拉伸 */
public func kRealValue(_ with: CGFloat) -> CGFloat {
    return with * SC_WIDTH
}
/** 可用来判断有刘海(height = 44),没刘海(height = 20) */
let kStatusBarHeight = KEYWINDOW.windowScene!.statusBarManager!.statusBarFrame.size.height

let kNavBarHeight: CGFloat = 44.0
let kTabBarHeight = kStatusBarHeight > 20 ? 83 : 49
/** 导航栏总高度 */
let kTopHeight = kStatusBarHeight + CGFloat(kNavBarHeight)
let KBottomBarHeight = (IS_IPHONE_X ? 34.0 : 0.0)

/** 卡片高度比例 */
let CardScale = (IS_IPHONE_X ? 1.38 :1.0)
/** 卡片数字高度比例 */
let CardnNumberScale = (IS_IPHONE_X ? 1.62 : 1.0)
/** 设置字体号 */
public func FONT_Regular(_ a: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Regular", size: a * SC_WIDTH)!
}
public func FONT_Medium(_ a: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Medium", size: a * SC_WIDTH)!
}
public func FONT_CondBold(_ a: CGFloat) -> UIFont {
    return UIFont(name: "FZYOUHS_512B--GB1-0", size: a * SC_WIDTH)!
}
public func FONT_HUNHJW(_ a: CGFloat) -> UIFont {
    return UIFont(name: "FZZZHUNHJW--GB1-0", size: a * SC_WIDTH)!
}

/** 获取Window */
let KEYWINDOW :UIWindow = UIApplication.shared.windows[0]
/** 弱引用 */
/* 防止参数为nil */
///* kAppContext */
//let kAppContext = AppContext.shareInstance
///** 用户ID */
//let TKD_USERID = Tools.shareInstance.userInfo.userId
///** 用户等级写死1 */
//let TKD_ACCOUNTLEVEL = Tools.shareInstance.userInfo.grade
///** 用户是否已经登录 */
//let isLogin = (TKD_USERID.count > 0)
///** 是否开启要健康 */
//let TKD_PERSONGIFTSTATUS = Tools.shareInstance.userInfo.personGiftStatus
/** 校验五要素名字 */
func Check_Name(text: String) -> Bool {
    return NSPredicate.init(format: "SELF MATCHES %@", "^[\u{4e00}-\u{9fa5a}-zA-Z]+([·\\s][\u{4e00}-\u{9fa5a}-zA-Z]+)*$").evaluate(with: text)
}
/** APP版本号 */
let CURRENTAPPVERSION: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
/** APP名称 */
let APPNAME = Bundle.main.infoDictionary!["CFBundleDisplayName"]
/** 更改服务器按钮是否隐藏 */
let HIDDENHOSTCHANGE = true
/** 加锁问题 YES （有锁） NO（无锁）*/
//let isLOCK [Tools shareInstance].userInfo.benLock

let SERVICENAME = "QW.QWScreenReplay.USER"
let SERVICENAMEACCOUTN = "QW.QWScreenReplay.USER.userIdentifier"
let QWUSERNAME = "QW.QWScreenReplay.USER.QWUSERNAME"
let QWUSEREMAIL = "QW.QWScreenReplay.USER.QWUSEREMAIL"
let QWUSEREIdentifier = "QW.QWScreenReplay.USER.Identifier"

let WELHEIGHT = kRealValue(3.5)

let LineHeight = 1.0 / UIScreen.main.scale

func dPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items, separator, terminator)
    #endif
}
let IS_IPHONE = UIDevice().userInterfaceIdiom == .phone


let IS_PAD = UIDevice().userInterfaceIdiom == .pad


