//
//  MTWXSDKProtocol.swift
//  MTWXIntegration
//
//  Created by 李宁 on 2018/12/28.
//  Copyright © 2018 李宁. All rights reserved.
//

import Foundation

protocol MTWXSDKProtocol {
    
    /// 获取微信登录的AccessToken
    ///
    /// - Parameters:
    ///   - urlStr: url字符串
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func mtwx_fetchLoginAccessToken(urlStr: String, success: (([String : Any]?) -> Void)?, fail: ((NSError) -> Void)?)
    
    /// 获取微信用户信息
    ///
    /// - Parameters:
    ///   - urlStr: url字符串
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func mtwx_fetchUserInfo(urlStr: String, success: (([String : Any]?) -> Void)?, fail: ((NSError) -> Void)?)
}

// MARK: - 微信登录相关
extension MTWXSDKProtocol {
    /// 获取微信登录的AccessToken
    ///
    /// - Parameters:
    ///   - urlStr: url字符串
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func mtwx_fetchLoginAccessToken(urlStr: String, success: (([String : Any]?) -> Void)?, fail: ((NSError) -> Void)?) {
        guard let url: URL = URL(string: urlStr) else {
            assertionFailure("微信登录获取AccessToken URL无效")
            return
        }
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err: NSError = error as NSError? {
                fail?(err)
                return
            }
            guard let responseData: Data = data else {
                let err: NSError = NSError(domain: "MTWXSDKLogin", code: -1, userInfo: [NSLocalizedDescriptionKey : "未获取到数据"])
                fail?(err)
                return
            }
            do {
                let dict: [String : Any]?  = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                success?(dict)
            } catch {
                let err: NSError = NSError(domain: "MTWXSDKLogin", code: -2, userInfo: [NSLocalizedDescriptionKey : "数据解析出错"])
                fail?(err)
            }
        }
        task.resume()
    }
    
    /// 获取微信用户信息
    ///
    /// - Parameters:
    ///   - urlStr: url字符串
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func mtwx_fetchUserInfo(urlStr: String, success: (([String : Any]?) -> Void)?, fail: ((NSError) -> Void)?) {
        guard let url: URL = URL(string: urlStr) else {
            assertionFailure("微信登录获取用户信息 URL无效")
            return
        }
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err: NSError = error as NSError? {
                fail?(err)
                return
            }
            guard let responseData: Data = data else {
                let err: NSError = NSError(domain: "MTWXSDKLogin", code: -3, userInfo: [NSLocalizedDescriptionKey : "未获取到数据"])
                fail?(err)
                return
            }
            do {
                let dict: [String : Any]?  = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                success?(dict)
            } catch {
                let err: NSError = NSError(domain: "MTWXSDKLogin", code: -4, userInfo: [NSLocalizedDescriptionKey : "数据解析出错"])
                fail?(err)
            }
        }
        task.resume()
    }
}
