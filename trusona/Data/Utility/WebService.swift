//
//  webService.swift
//  Tru_MFA
//
//  Created by deguMac on 2018/11/23.
//  Copyright © 2018 deguMac. All rights reserved.
//

import Foundation
import UIKit

class WebService {
    // ユーザーを登録する。
    func register(email: String,
                  password: String,
                  deviceIdentifier: String,
                  completionHandler: ((String?) -> ())?) {
        
        let request: Request = Request()
        
//        let url: URL = URL(string: Config.SERVER_URL + Config.SERVER_API_PATH)!
        let url: URL = URL(string: Config.SERVER_URL +
            Config.SERVER_API_PATH +
            "?email=" + email +
            "&password=" + password +
            "&deviceIdentifier=" + deviceIdentifier)!
//        var body = Dictionary<String,Any>()
//        body["email"] = email
//        body["password"] = password
//        body["deviceIdentifier"] = deviceIdentifier
        
//            try request.post(url: url, body: body, completionHandler: { data, response,
        request.get(url: url, completionHandler: { data, response,
            error in
            if (error == nil) {
                let str: String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                do {
                    guard let data = data else { return } // dataはサーバから取得したバイナリデータ
                    guard let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                    let jsonObject = JSONObject(json: dic)
                    let response = try ApiResponse(json: jsonObject)
                    completionHandler!(String.init(response.success))
                } catch let error {
                    print(error)
                    completionHandler!(str)
                }
            } else {
                // 通信失敗
                print(error.debugDescription)
                completionHandler!("ERROR")
            }
        })
    }
    
    // ユーザーを削除する。
    func remove(email: String, deviceIdentifier: String, completionHandler: ((String?) -> ())?) {
        
        let request: Request = Request()
        
        let url: URL = URL(string: Config.SERVER_URL + Config.SERVER_API_PATH)!
        
        var body = Dictionary<String,Any>()
        body["email"] = email
        body["deviceIdentifier"] = deviceIdentifier
        
        do {
            try request.post(url: url, body: body, completionHandler: { data, response, error in
                if (error == nil) {
                    let str: String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                    do {
                        guard let data = data else { return } // dataはサーバから取得したバイナリデータ
                        guard let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                        let jsonObject = JSONObject(json: dic)
                        let response = try ApiResponse(json: jsonObject)
                        // TEST
                        print(response.message)
                        completionHandler!(String.init(response.success))
                    } catch let error {
                        print(error)
                        completionHandler!(str)
                    }
                } else {
                    // 通信失敗
                    print(error.debugDescription)
                    completionHandler!("ERROR")
                }
            })
        } catch {
            completionHandler!("ERROR")
        }
    }
    
    func urlEncode(url: String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
