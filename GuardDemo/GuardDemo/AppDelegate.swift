//
//  AppDelegate.swift
//  GuardDemo
//
//  Created by Lance Mao on 2021/11/23.
//

import Guard
import Wechat
import WeCom
import OneAuth
import LarkLogin
import AppAuth
import Google
import Facebook
import UserNotifications
import Tencent
import Weibo
import Baidu
import Facebook
import Linkedin
import DingTalk

let lark_scheme = "clia2b69a679b3a900b"
let WECHAT_APPID = "wx1cddb15e280c0f67"
let WECOM_APPID = "wwauthb67a4e1963a53716000081"
let WECOM_CORPID = "wwb67a4e1963a53716"
let WECOM_AGENTID = "1000081"
let QQ_APPID = "102043018"
let SINA_APPID = "884123079"
let BAIDU_APPID = "30984028"
let DINGTALK_APPID = "dingmtephhdvox58ox5d"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        
        WechatLogin.registerApp(appId: WECHAT_APPID, universalLink: "https://h5-static.authing.co/app/")
        WeCom.registerApp(appId: WECOM_APPID, corpId: WECOM_CORPID, agentId: WECOM_AGENTID, isProxyDevelopment: false)
        OneAuth.register(businessId: "fdaf299f9d8f43c0a41ad3c2ca5c02f6")
        LarkLogin.setupLark("cli_a2b69a679b3a900b", Scheme: lark_scheme)
        Google.register(clientID: "416092875790-gk29o58aein6vrkneb3vd1bki91b5his.apps.googleusercontent.com", serverClientId: "416092875790-usvrkoj06srkmalel5ld6selsk2rq35r.apps.googleusercontent.com")
        Facebook.register(application, didFinishLaunchingWithOptions: launchOptions)
        Tencent.register(appId: QQ_APPID, universalLink: "https://h5-static.authing.co/qq_conn/102043018")
        Weibo.register(appId: SINA_APPID, scope: "all", redirectURI:"https://core.authing.cn/connection/social/me-wbmb/63156d74f35ddccf48ca0ef0/callback", universalLink: "https://h5-static.authing.co")
        Baidu.register(appKey: "W7q5yrakQpnjYStDkNGIxmGK", appId: BAIDU_APPID, scope: "basic,super_msg", redirectURI: "https://core.authing.cn/connection/social/baidu/6204d0a406f0423c78f243ae/callback")
        Linkedin.register(clientId: "78pbphbop997ms", permissions: "r_liteprofile", redirectURI: "https://core.mysql.authing-inc.co/connection/social/linkedin/6391c767ddbe9b6ee8db0fb2/callback")
        DingTalk.register(appId: DINGTALK_APPID, bundleId: "cn.authing.mobile")
        Authing.start("6244398c8a4575cdb2cb5656");

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Authing.NotifyName.notify_wechat.rawValue), object: userActivity)
        if let url = userActivity.webpageURL {
            if "\(url)".contains(QQ_APPID) {
                return  Tencent.handleUniversalLink(url: url)
            } else if "\(url)".contains(SINA_APPID) {
                return  Weibo.handleUniversalLink(userActivity: userActivity)
            }
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if "\(url)".contains(lark_scheme) {
            return LarkLogin.handleUrl(url: url)
        } else if "\(url)".contains(Facebook.getAppId()) {
            return Facebook.application(app, open: url, options: options)
        } else if "\(url)".contains(WECHAT_APPID) {
            return WechatLogin.handleOpenURL(url: url)
        } else if "\(url)".contains(QQ_APPID) {
            return Tencent.handleURL(url: url)
        } else if "\(url)".contains(SINA_APPID) {
            return Weibo.handleURL(url: url)
        } else if "\(url)".contains(BAIDU_APPID) {
            return Baidu.handleURL(url: url)
        } else if "\(url)".contains(DINGTALK_APPID) {
            return DingTalk.handleURL(url: url)
        } else {
            return WeCom.handleOpenURL(url: url)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
}
