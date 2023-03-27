//
//  SampleListViewController.swift
//  GuardDemo
//
//  Created by Lance Mao on 2021/11/23.
//

import Guard
import UIKit
import OneAuth

class SampleListViewController: UITableViewController {

    let from = ["Authing Login",
                "Biometric Authentication",
                "Social Hyper Component",
                "手机号一键登录",
                "MFA",
                "用户信息补全",
                "WebView",
                "AppAuth",
                "OIDCClient",
                "HCML Parser"]

    let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return from.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        cell.textLabel?.text = from[indexPath.row]
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch from[indexPath.row] {
        case "Authing Login":
            Authing.start("6244398c8a4575cdb2cb5656")
            let flow = AuthFlow()
            flow.UIConfig = AuthFlowUIConfig()
            flow.UIConfig?.contentMode = .center
            flow.start { [weak self] code, message, userInfo in
                self?.goHome(userInfo: userInfo)
            }
            return
        case "Biometric Authentication":
            Authing.start("64006a897ee99ecbba8c8b16")
            let flow = AuthFlow()
            flow.start { [weak self] code, message, userInfo in
                self?.goHome(userInfo: userInfo)
            }
            return
        case "Social Hyper Component":
            let vc: AuthViewController? = AuthViewController(nibName: "Test", bundle: Bundle(for: Self.self))
            self.navigationController?.pushViewController(vc!, animated: true)
            return
        case "手机号一键登录":
            OneAuth.start(self) { [weak self]  code, message, userInfo in
                if (code == 200 && userInfo != nil) {
                    self?.goHome(userInfo: userInfo)
                } else {
                    print(message ?? "OneAuth unknow error")
                }
            }
            return
        case "MFA":
            Authing.start("6411662375e3ccdf766d9f86")
            AuthFlow().start { [weak self] code, message, userInfo in
                self?.goHome(userInfo: userInfo)
            }
            return
        case "用户信息补全":
            Authing.start("61ae0c9807451d6f30226bd4")
            AuthFlow().start { [weak self] code, message, userInfo in
                self?.goHome(userInfo: userInfo)
            }
            return
        case "WebView":
            Authing.start("6244398c8a4575cdb2cb5656")
            let vc = WebViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "AppAuth":
            Authing.start("6244398c8a4575cdb2cb5656")
            let vc = AppAuthViewController(nibName: "AppAuth", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "OIDCClient":
            Authing.start("6244398c8a4575cdb2cb5656")
            let flow = AuthFlow()
            let uiconfig = AuthFlowUIConfig()
            uiconfig.contentMode = .center
            flow.UIConfig = uiconfig
            flow.authProtocol = .EOIDC
            flow.start()  { [weak self] code, message, userInfo in
                self?.goHome(userInfo: userInfo)
            }
            return
        case "HCML Parser":
            Authing.start("62345c87ffe7c884acbae53c")
            AuthFlow().startAppBundle("62345c87ffe7c884acbae53c") { [weak self] code, message, userInfo in
                self?.goHome(userInfo: userInfo)
            }                
            return
        default:
            return
        }
    }
    
    private func goHome(userInfo: UserInfo?) {
        let vc = MainViewController(nibName: "AuthingUserProfile", bundle: Bundle(for: UserProfileViewController.self))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
