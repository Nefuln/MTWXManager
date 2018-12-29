//
//  MTThirdLogin.swift
//  MTWXIntegration
//
//  Created by 李宁 on 2018/12/28.
//  Copyright © 2018 李宁. All rights reserved.
//

import UIKit

enum MTWXSDKType {
    case Login          // 登录
    case Share          // 分享
    case Pay            // 支付
}

class MTWXSDKManager: NSObject, MTWXSDKProtocol {
    /// 单例
    static let manager = MTWXSDKManager()
    private override init() {
        super.init()
    }
    
    /// 注册WXSDK
    ///
    /// - Parameter appid: 微信Appid
    func registWX(_ appid: String) {
        self.appid = appid
        WXApi.registerApp(appid)
    }
    
    /// 处理微信通过URL启动App时传递的数据, 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
    ///
    /// - Parameter url: 微信启动第三方应用时传递过来的URL
    /// - Returns: 成功返回YES，失败返回NO。
    func handleOpenUrl(_ url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    /// 微信Appid
    internal var appid: String = ""
    
    /// 秘钥
    internal var appSecret: String = ""
    
    
    // MARK: - 登录相关
    
    /// 用户信息
    internal var userInfo: MTWXUserInfoModel?
    
    /// 登录成功回调
    internal var loginSuccessBlock: ((MTWXUserInfoModel) -> Void)?
    
    /// 登录失败回调
    internal var loginFailBlock: ((NSError?) -> Void)?
    
    
    // MARK: - 分享
    
    /// 分享成功回调
    internal var shareCompletionBlock: (() -> Void)?
    
    /// 分享失败回调
    internal var shareFailBlock: ((NSError?) -> Void)?
    
}

extension MTWXSDKManager {
    /// 从微信返回当前应用后的回调
    ///
    /// - Parameter resp: 相应事件的模型
    func onResp(_ resp: BaseResp!) {
        
        /// 处理登录回调事件
        if let loginResp: SendAuthResp = resp as? SendAuthResp {
            self.handleLoginEvent(authResp: loginResp)
        } else if let shareResp: SendMessageToWXResp = resp as? SendMessageToWXResp {
            self.handleShareEvent(resp: shareResp)
        }
    }
}
