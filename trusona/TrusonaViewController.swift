//
//  DeviceViewController.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/25.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation
import TrusonaSDK
import SVGKit

// 初期画面。
class TrusonaViewController : CommonTrusonaViewController, UITextFieldDelegate {
    // ローディング画像。
    @IBOutlet weak var loading: UIImageView!
    // 画面が表示された時。
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        
        trusona.getDeviceIdentifier { (identifier, result) in
            print(identifier as Any)
            switch result {
            case Trusona.DeviceRetrievalResult.newDevice:
                // 新規デバイスの場合。
                let next = self.storyboard!.instantiateViewController(withIdentifier: "register")
                self.present(next, animated: true, completion: nil)
                break
            case Trusona.DeviceRetrievalResult.inactiveDevice:
                // 非活性デバイスの場合。
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let next = storyboard.instantiateViewController(withIdentifier: "register")
                self.present(next, animated: true, completion: nil)
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
    
    func showLoading() {
        
    }
}
