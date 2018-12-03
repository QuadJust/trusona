//
//  Trusonafy.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/27.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation
import TrusonaSDK

class Trusonafy {
    var trusona = Trusona(
        token: Config.TRUSONA_TOKEN,
        secret: Config.TRUSONA_SECRET)
    
    var parent: CommonTrusonaViewController!
    
    var status: String!
    var deviceIdentifier: String!
    
    init() {
        let delegate: TrusonaficationUIDelegate! = trusona.trusonaficationUIDelegate
    }
    
    func startMonitoring(
        message: String,
        completionHandler: ((String) -> ())?) {
        print("---------- Start monitoring")
        
        trusona.monitorPendingTrusonafications(
            checkInterval: .seconds(2),
            viewController: parent,
            onCompleted: {
                result in
                var ret = "NG"
                switch ( result ) {
                case .success :
                    print("------- Success")
                    ret = "OK"
                case .failure:
                    print("------- Failure")
                case .expired:
                    print("------- Expired")
                case .none:
                    print("------- None")
                }
                if completionHandler != nil {
                    completionHandler!(ret)
                }
        },
            failure: {
                error in
                print("------- Trusonafication failure")
                if completionHandler != nil {
                    completionHandler!("NG")
                }
        })
    }
    func stopMonitoring() {
        print("---------- Stop monitoring")
        trusona.stopMonitoringPendingTrusonafications()
    }
    func startScan() throws {
        print("------------------- get_scanner")
        try trusona.startScanner(on: parent)
    }
    
    func getScanner() throws -> UIViewController {
        print("------------------- get_scanner")
        return try self.trusona.getScanner(truCodePaired: {
            self.parent.showWaitView(show: true)
            /*self.parent.dismiss(animated: true, completion: {
                print("------------------- dismiss_scanner")
            })*/
        })
    }
    
    func checkDevice() {
        trusona.getDeviceIdentifier { (identifier, result) in
            print(identifier ?? "none")
            self.deviceIdentifier = identifier
            
            var identifier: String!
            
            switch result {
            case .activeDevice:
                print("---------- activeDevice")
                self.status = "activeDevice"
                if UserDefaults.standard.object(forKey: "email") == nil {
                    self.resetDevice()
                }
                identifier = "toLogin"
            case .inactiveDevice:
                self.trusona.resetKeys()
                print("---------- inactiveDevice")
                self.status = "inactiveDevice"
                identifier = "toRegister"
            case .newDevice:
                print("---------- newDevice")
                self.status = "newDevice"
                identifier = "toRegister"
            default:
                print("---------- error")
                self.status = "error"
            }
            
            self.parent.performSegue(withIdentifier: identifier, sender: nil)
        }
    }
    func resetDevice() {
        print("------------------- reset_device")
        trusona.resetKeys()
    }
}
