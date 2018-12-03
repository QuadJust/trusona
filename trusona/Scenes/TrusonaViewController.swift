//
//  DeviceViewController.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/25.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation
import TrusonaSDK
import LocalAuthentication

// TRUSONAビューコントローラ。
class TrusonaViewController : CommonTrusonaViewController, UITextFieldDelegate {
    // ロード時。
    override func viewDidLoad() {
        super.viewDidLoad()
        //trusonafy.checkDevice()
    }
    // 初期表示時。
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trusonafy.checkDevice()
        /*if UserDefaults.standard.object(forKey: "email") == nil {
            self.performSegue(withIdentifier: "toRegister", sender: nil)
        } else {
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }*/
        showWaitView(show: false)
    }
    // 表示準備時。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegister" {
            let setting: SettingViewController = (segue.destination as? SettingViewController)!
            setting.trusonafy = trusonafy
        } else {
            let login: LoginViewController = (segue.destination as? LoginViewController)!
            login.trusonafy = trusonafy
            login.isScan = true
        }
    }
    
    // 多要素認証。
    func mfa_req() {
        
        let userid = UserDefaults.standard.object(forKey: "email") as! String
        let apiUrl = URL(string: urlEncode(string: "https://trusonajp.herokuapp.com/tru_app/mfa?USERID="+userid+"&UP=YES"))
        let request = URLRequest(url: apiUrl!)
        URLSession.shared.dataTask(with: request) {data, response, err in
            if (err == nil) {
                let str: String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                if str == "OK" {
                    print("-------------------- MFA request complete")
                } else {
                    print("-------------------- MFA failed")
                }
                print(str)
            } else {
                // API通信失敗
                print("-------------------- MFA error")
            }
            }.resume()
    }
    
}
