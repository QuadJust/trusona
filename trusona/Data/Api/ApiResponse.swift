//
//  JsonResponse.swift
//  trusona
//
//  Created by shinri ishikawa on 2018/11/28.
//  Copyright © 2018年 inet. All rights reserved.
//

import Foundation

struct ApiResponse: JSONDecodable {
    init(json: JSONObject) throws {
        success = try json.get("success")
        message = try json.get("message")
        content = try json.get("content")
    }
    
    var success: Bool!
    var message: String!
    var content: String!
}
