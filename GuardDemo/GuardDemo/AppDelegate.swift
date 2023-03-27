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
import Github
import Gitee
import Douyin
import Kuaishou
import GitLab
import Xiaomi
import AppAuthCore

let LARK_APPID = ""
let LARK_SCHEME = ""
let WECHAT_APPID = ""
let WECOM_APPID = ""
let WECOM_CORPID = ""
let WECOM_AGENTID = ""
let QQ_APPID = ""
let SINA_APPID = ""
let SINA_REDIRECT = ""
let BAIDU_APPID = ""
let BAIDU_APPKEY = ""
let BAIDU_REDIRECT = ""
let DINGTALK_APPID = ""
let DINGTALK_BUNDLEID = ""
let ONEAUTH_BUSINESSID = ""
let GOOGLE_CLIENTID = ""
let GOOGLE_SERVER_CLIENTID = ""
let LINKEDIN_CLIENTID = ""
let LINKEDIN_REDIRECT = ""
let GITHUB_APPID = ""
let GITHUB_REDIRECT = ""
let GITEE_REDIRECT = ""
let GITEE_APPID = ""
let GITLAB_APPID = ""
let GITLAB_REDIRECT = ""
let DOUYIN_APPID = ""
let KUAISHOU_APPID = ""
let UNIVERSAL_LINK = ""
let XIAOMI_APPID = ""
let XIAOMI_REDIRECTURL = ""

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var window:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        
        WechatLogin.registerApp(appId: WECHAT_APPID, universalLink: "https://h5-static.authing.co/app/")
        WeCom.registerApp(appId: WECOM_APPID, corpId: WECOM_CORPID, agentId: WECOM_AGENTID, isProxyDevelopment: false)
        OneAuth.register(businessId: ONEAUTH_BUSINESSID)
        LarkLogin.setupLark(LARK_APPID, Scheme: LARK_SCHEME)
        Google.register(clientID: GOOGLE_CLIENTID, serverClientId: GOOGLE_SERVER_CLIENTID)
        Facebook.register(application, didFinishLaunchingWithOptions: launchOptions)
        Tencent.register(appId: QQ_APPID, universalLink: "https://h5-static.authing.co/qq_conn/102043018")
        Weibo.register(appId: SINA_APPID, scope: "all", redirectURI: SINA_REDIRECT , universalLink: "https://h5-static.authing.co")
        Baidu.register(appKey: BAIDU_APPKEY, appId: BAIDU_APPID, scope: "basic,super_msg", redirectURI: BAIDU_REDIRECT)
        Linkedin.register(clientId: LINKEDIN_CLIENTID, permissions: "r_liteprofile", redirectURI: LINKEDIN_REDIRECT)
        DingTalk.register(appId: DINGTALK_APPID, bundleId: DINGTALK_BUNDLEID)
        Github.register(appId: GITHUB_APPID, redirectURI: GITHUB_REDIRECT)
        Gitee.register(appId: GITEE_APPID, redirectURI: GITEE_REDIRECT)
        GitLab.register(appId: GITLAB_APPID, redirectURI: GITLAB_REDIRECT)
        Douyin.register(appId: DOUYIN_APPID, application, didFinishLaunchingWithOptions: launchOptions)
        Kuaishou.register(appId: KUAISHOU_APPID, universalLink: UNIVERSAL_LINK)
        Xiaomi.register(appId: XIAOMI_APPID, redirectUrl: XIAOMI_REDIRECTURL)
        Authing.start("6244398c8a4575cdb2cb5656");
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
        
        if "\(url)".contains(LARK_SCHEME) {
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
