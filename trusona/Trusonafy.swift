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
    let trusona = Trusona(
        token: Configs.TRUSONA_TOKEN,
        secret: Configs.TRUSONA_SECRET)
    
    var parent: UIViewController!
    
    var status: String!
    var devid: String!
    
    func startMonitoring(message: String, completionHandler: ((String) -> ())?) {
        
        print("---------- Start monitoring")
        
        trusona.monitorPendingTrusonafications(checkInterval: .seconds(2), viewController: parent,
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
    func check_device() {
        
        trusona.getDeviceIdentifier { (identifier, result) in
            print(identifier ?? "none")
            self.devid = identifier
            
            switch result {
            case .activeDevice:
                print("---------- activeDevice")
                self.status = "activeDevice"
                if UserDefaults.standard.object(forKey: "USERID") == nil {
                    self.reset_device()
                }
            case .inactiveDevice:
                self.trusona.resetKeys()
                print("---------- inactiveDevice")
                self.status = "inactiveDevice"
            case .newDevice:
                print("---------- newDevice")
                self.status = "newDevice"
            default:
                print("---------- error")
                self.status = "error"
            }
        }
    }
    func reset_device() {
        print("------------------- reset_device")
        trusona.resetKeys()
    }
}
