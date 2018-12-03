//
//  RegisterViewController.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/26.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation
import TrusonaSDK
// 設定画面。
class SettingViewController : CommonTrusonaViewController, UITextFieldDelegate {
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    let service = WebService()
    // ロード時。
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 初期表示時。
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if trusonafy.status != "activeDevice" {
            setText(flag: false)
        } else {
            setText(flag: true)
        }
        showWaitView(show: false)
    }
    
    func setText(flag:  Bool) {
        emailLabel.text = Const.EMAIL_LABEL
        passwordLabel.text = Const.PASSWORD_LABEL
        if flag {
            registerLabel.text = Const.REMOVE_MESSAGE
            registerLabel.numberOfLines = 0
            email.text = UserDefaults.standard.object(forKey: "email") as? String
            password.text = ""
            email.isEnabled = false
            password.isEnabled = false
            okButton.setTitle(Const.REMOVE_BUTTON, for: UIControl.State.normal)
        } else {
            registerLabel.text = Const.REGISTER_MESSAGE
            registerLabel.numberOfLines = 0
            email.text = ""
            password.text = ""
            email.isEnabled = true
            password.isEnabled = true
            email.placeholder = Const.EMAIL_PLACE_HOLDER
            password.placeholder = Const.PASSWORD_PLACE_HOLDER
            password.isSecureTextEntry = true
            okButton.setTitle(Const.REGISTER_BUTTON, for: UIControl.State.normal)
        }
    }
    
    @IBAction func settingAction(_ sender: Any) {
        
        let cmd = okButton.titleLabel?.text
        var alert: UIAlertController!
        self.view.endEditing(true)
        print("------------------- ok_setting button")
        
        if cmd == Const.REGISTER_BUTTON {
            alert = UIAlertController(
                title: Const.CONFIRM,
                message: Const.CONFIRM_REGISTER,
                preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(
                title: Const.YES,
                style: UIAlertAction.Style.default,
                handler: {    (action:UIAlertAction!) in
                    print("you have pressed the OK button")
                    self.showWaitView(show: true)
                    self.registerDevice() 
            }))
        } else {
            alert = UIAlertController(
                title: Const.CONFIRM,
                message: Const.CONFIRM_REMOVE,
                preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(
                title: Const.YES,
                style: UIAlertAction.Style.default,
                handler: {    (action:UIAlertAction!) in
                    print("you have pressed the OK button")
                    self.showWaitView(show: true)
                    self.removeDevice()
            }))
        }
        
        alert.addAction(UIAlertAction(
            title: Const.NO,
            style: UIAlertAction.Style.default,
            handler: {    (action:UIAlertAction!) in
                print("you have pressed the Cancel button")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func registerDevice() {
        let email = self.email.text
        let password = self.password.text
        service.register(
            email: email!,
            password: password!,
            deviceIdentifier: trusonafy.deviceIdentifier) { ( result : String?) in
                self.showWaitView(show: false)
                // FIXME ここはsuccessにしたい
                if result == "true" {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(email, forKey: "email")
                        print("------------------ Register complete")
                        self.showAlert(
                            title: Const.USER_REGISTER,
                            message: Const.USER_REGISTER_SUCCESS,
                            completionHandler: {
                                self.setText(flag: true)
                                self.dismiss(animated: true)
                        })
                    }
                } else {
                    print("Register failure")
                    self.showAlert(
                        title: Const.USER_REGISTER,
                        message: Const.USER_REGISTER_FAILURE,
                        completionHandler: nil)
                }
        }
    }
    
    func removeDevice() {
        
        self.showWaitView(show: true)
        self.service.remove(email: self.email.text!,
                            deviceIdentifier: self.trusonafy.deviceIdentifier,
                            completionHandler: {
                                ( result : String?) in
                                self.showWaitView(show: false)
                                if result == "OK" {
                                    DispatchQueue.main.async {
                                        self.trusonafy.resetDevice()
                                        UserDefaults.standard.removeObject(forKey: "email")
                                        UserDefaults.standard.removeObject(forKey: "password")
                                        print("------------------ Delete complete")
                                        self.showAlert(title: "ユーザー登録",message: "削除されました", completionHandler: {
                                            self.setText(flag: false)
                                        })
                                    }
                                } else {
                                    print("Delete error")
                                    self.showAlert(title: "ユーザー登録",message: "削除に失敗しました", completionHandler: nil)
                                }
        })
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
