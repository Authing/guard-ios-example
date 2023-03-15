//
//  SceneDelegate.swift
//  GuardDemo
//
//  Created by Lance Mao on 2021/11/23.
//

import Guard
import Wechat
import WeCom
import LarkLogin
import Facebook
import Tencent
import Weibo
import Baidu
import DingTalk

class SceneDelegate: UIResponder, UIWindowSceneDelegate, WXApiDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            if "\(url)".contains(QQ_APPID) {
                _ = Tencent.handleUniversalLink(url: url)
            } else if "\(url)".contains(SINA_APPID) {
                _ = Weibo.handleUniversalLink(userActivity: userActivity)
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Authing.NotifyName.notify_wechat.rawValue), object: userActivity)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url{
            if "\(url)".contains(LARK_SCHEME) {
                _ = LarkLogin.handleUrl(url: url)
            } else if "\(url)".contains(WECHAT_APPID) {
                _ =  WechatLogin.handleOpenURL(url: url)
            } else if "\(url)".contains(QQ_APPID) {
                _ = Tencent.handleURL(url: url)
            } else if "\(url)".contains(SINA_APPID) {
                _ = Weibo.handleURL(url: url)
            } else if "\(url)".contains(BAIDU_APPID) {
                _ = Baidu.handleURL(url: url)
            } else if "\(url)".contains(DINGTALK_APPID) {
                _ = DingTalk.handleURL(url: url)
            } else {
                _ = WeCom.handleOpenURL(url: url)
            }
        }
    }
}

