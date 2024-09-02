//
//  SNSProtocol.swift
//  moments-ios
//
//  Created by akari on 2024/9/2.
//

import UIKit
import Just

protocol SNSProtocol {
    var title:String { get }
    func login(data:[String: Any],action:((Bool)->Void))
    func load()
}

class MomentsApi:SNSProtocol {
    var title: String = "极简朋友圈"
    var base_url:String!
    var login_token = ""
    
    init(base_url:String){
        self.base_url = base_url
    }
    
    func login(data:[String: Any],action:((Bool)->Void)) {
        let json = Just.post("\(self.base_url!)/api/user/login",data:data)
        if let httpResponse = json.response as? HTTPURLResponse {
            if let setCookieHeader = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                let dic = getCookie(setCookieHeader: setCookieHeader)
                login_token = dic["token"]!
                action(true)
                return
            }
        }
        action(false)
    }
    
    func load() {
        
    }
    
    
}
