//
//  RegisterViewController.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/26.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation
import TrusonaSDK
// 登録画面。
class RegisterViewController : CommonTrusonaViewController, UITextFieldDelegate {
    // メールアドレス入力欄。
    var email:UITextField!
    // メールアドレスラベル。
    var emailLabel:UILabel!
    // パスワード入力欄。
    var password:UITextField!
    // パスワードラベル。
    var passwordLabel:UILabel!
    // 画面が表示された時。
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trusona.getDeviceIdentifier { (identifier, result) in
            print(identifier as Any)
            switch result {
            case Trusona.DeviceRetrievalResult.newDevice:
                self.showEmailTextfield()
                break
            case Trusona.DeviceRetrievalResult.inactiveDevice:
                self.showEmailTextfield()
                break
            case Trusona.DeviceRetrievalResult.activeDevice:
                
                break
            case Trusona.DeviceRetrievalResult.securityDisabled:
                
                break
            case Trusona.DeviceRetrievalResult.securityEnabled:
                
                break
            default:
                // エラーメッセージ表示
                exit(-1)
            }
        }
    }
    
    func showEmailTextfield() {
        //UITextFieldのインスタンスを作成
        email = UITextField()
        
        //textfieldの位置とサイズを設定
        email.frame = CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 15, width: 200, height: 30)
        
        //Delegateを自身に設定
        email.delegate = self
        
        //アウトラインを表示
        email.borderStyle = .roundedRect
        
        //入力している文字を全消しするclearボタンを設定(書いている時のみの設定)
        email.clearButtonMode = .whileEditing
        
        //改行ボタンを完了ボタンに変更
        email.returnKeyType = .done
        
        //文字が何も入力されていない時に表示される文字(薄っすら見える文字)
        email.placeholder = "入力してください"
        
        //viewにtextfieldをsubviewとして追加
        self.view.addSubview(email)
    }
    
    func sendDeviceIdentifier() {
        let request: Request = Request()
        
        let url: URL = URL(string: Configs.TRUSONA_SERVER_DOMAIN)!
        let body: NSMutableDictionary = NSMutableDictionary()
        body.setValue("value", forKey: "key")
        
        do {
            try request.post(url: url,
                             body: body,
                             completionHandler: { data, response, error in
                                // code
                                
            })
        } catch {
            
        }
    }
}
