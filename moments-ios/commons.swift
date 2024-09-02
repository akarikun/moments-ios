//
//  commons.swift
//  moments-ios
//
//  Created by akari on 2024/9/2.
//

import UIKit

func getCookie(setCookieHeader:String)->[String:String]{
    let pattern = "([^;]+)=([^;]+)"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: setCookieHeader, options: [], range: NSRange(location: 0, length: setCookieHeader.utf16.count))
    var dic = [String:String]()
    for match in matches {
        if let nameRange = Range(match.range(at: 1), in: setCookieHeader),
            let valueRange = Range(match.range(at: 2), in: setCookieHeader) {
            let cookieName = String(setCookieHeader[nameRange])
            let cookieValue = String(setCookieHeader[valueRange])
//            print("Cookie Name: \(cookieName), Cookie Value: \(cookieValue)")
            dic[cookieName] = cookieValue
        }
    }
    return dic
}
