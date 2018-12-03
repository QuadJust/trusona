//
//  ScannerViewController.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/20.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation
import TrusonaSDK

class LoginViewController: CommonTrusonaViewController {
    // スキャン開始フラグ。
    var isScan: Bool!
    
    // ロード時。
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 初期表示時。
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (isScan) {
            do {
                let scanner = try trusonafy.getScanner()
                self.present(scanner, animated: true)
            } catch {
                
            }
        }
    }
    
    override func showWaitView(show: Bool) {
        self.isScan = !show
        DispatchQueue.main.async {
            if (self.waitView != nil && self.indicator != nil) {
                self.waitView.isHidden = !show
                self.indicator.isHidden = !show
                if( show ) {
                    self.indicator.startAnimating()
                } else {
                    self.indicator.stopAnimating()
                }
            }
        }
        if (show) {
            trusonafy.startMonitoring(message: "ログインの確認を求めています") { ret in
                print("-------------- Got MFA")
                //self.trusonafy.stopMonitoring()
                self.showWaitView(show: false)
                if ret == "OK" {
                    self.reload()
                } else {
                    self.showAlert(title: "ユーザー認証",message: "認証に失敗しました", completionHandler: self.reload)
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func reload() {
        self.loadView()
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
}
